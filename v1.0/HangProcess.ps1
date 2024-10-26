<# HangProcess v1.0
   Developer: github.com/zsr-lukezhang
   Repo: github.com/zsr-lukezhang/HangProcess
   Download: github.com/zsr-lukezhang/HangProcess/releases/tag/v1.0
#>

# This script is only for HANGING the process.
# Use HangProcess.ps1 to RESUME the process.

$host.ui.RawUI.WindowTitle = "HangProcess v1.0 - HangProcess.ps1"


Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class ProcessExtension
{
    [DllImport("ntdll.dll", SetLastError = true)]
    private static extern int NtSuspendProcess(IntPtr processHandle);

    [DllImport("ntdll.dll", SetLastError = true)]
    private static extern int NtResumeProcess(IntPtr processHandle);

    public static void SuspendProcess(int processId)
    {
        var process = System.Diagnostics.Process.GetProcessById(processId);
        NtSuspendProcess(process.Handle);
    }

    public static void ResumeProcess(int processId)
    {
        var process = System.Diagnostics.Process.GetProcessById(processId);
        NtResumeProcess(process.Handle);
    }
}
"@

function Suspend-Process {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProcessName
    )
    $process = Get-Process -Name $ProcessName
    foreach ($p in $process) {
        [ProcessExtension]::SuspendProcess($p.Id)
    }
}

# Change "POWERPNT" to the process name you actually want to hang.
# "POWERPNT" is the executable file name of PowerPoint.

Suspend-Process -ProcessName "POWERPNT"
