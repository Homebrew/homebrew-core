class Dotnet < Formula
  desc ".Net Core"
  homepage "https://github.com/dotnet/cli/releases"
  url "https://github.com/dotnet/cli/archive/v1.0.0-preview2.tar.gz"
  sha256 "a0708ed3eedb10e95dcea96c62f85be1c38b91f2be9afa89d8fc655b7e0c4706"

  patch :DATA
  head "https://github.com/dotnet/cli.git"

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    system "./build.sh", "--targets", "Prepare,Compile"

    # Relink openssl to the homebrew version
    # Would be smoother to tell clang to use this openssl prefix, but alas...
    openssl_path = Formula["openssl"].opt_prefix

    stage2 = buildpath/"artifacts/osx.#{MacOS.version}-x64/stage2"
    system "install_name_tool -add_rpath #{openssl_path}/lib #{stage2}/shared/Microsoft.NETCore.App/1.0.0/System.Security.Cryptography.Native.dylib"

    prefix.install Dir["#{stage2}/*"]
  end

  test do
    system prefix/"dotnet", "version"
  end
end
__END__
---
 build_projects/dotnet-cli-build/PrepareTargets.cs           | 9 ---------
 build_projects/shared-build-targets-utils/Utils/GitUtils.cs | 4 ++--
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/build_projects/dotnet-cli-build/PrepareTargets.cs b/build_projects/dotnet-cli-build/PrepareTargets.cs
index 5e6b948..3af853b 100644
--- a/build_projects/dotnet-cli-build/PrepareTargets.cs
+++ b/build_projects/dotnet-cli-build/PrepareTargets.cs
@@ -464,15 +464,6 @@ public static BuildTargetResult CheckPrereqCmakePresent(BuildTargetContext c)
         [Target]
         public static BuildTargetResult SetTelemetryProfile(BuildTargetContext c)
         {
-            var gitResult = Cmd("git", "rev-parse", "HEAD")
-                .CaptureStdOut()
-                .Execute();
-            gitResult.EnsureSuccessful();
-
-            var commitHash = gitResult.StdOut.Trim();
-
-            Environment.SetEnvironmentVariable("DOTNET_CLI_TELEMETRY_PROFILE", $"https://github.com/dotnet/cli;{commitHash}");
-
             return c.Success();
         }

diff --git a/build_projects/shared-build-targets-utils/Utils/GitUtils.cs b/build_projects/shared-build-targets-utils/Utils/GitUtils.cs
index bae5c67..522958f 100644
--- a/build_projects/shared-build-targets-utils/Utils/GitUtils.cs
+++ b/build_projects/shared-build-targets-utils/Utils/GitUtils.cs
@@ -6,12 +6,12 @@ public static class GitUtils
     {
         public static int GetCommitCount()
         {
-            return int.Parse(ExecuteGitCommand("rev-list", "--count", "HEAD"));
+            return 3121;
         }

         public static string GetCommitHash()
         {
-            return ExecuteGitCommand("rev-parse", "HEAD");
+            return "1e9d529bc54ed49f33102199e109526ea9c6b3c4";
         }

         private static string ExecuteGitCommand(params string[] args)
--
