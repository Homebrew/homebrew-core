class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  # Source-build tag announced at https://github.com/dotnet/source-build/discussions
  url "https://github.com/dotnet/installer.git",
      tag:      "v7.0.100-rtm.22521.12",
      revision: "e12b7af219b96b5e07039ea8e3e268380329d72c"
  version "7.0.100"
  license "MIT"

  # https://github.com/dotnet/source-build/#support
  livecheck do
    url "https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/releases-index.json"
    regex(/unused/i)
    strategy :page_match do |page|
      index = JSON.parse(page)["releases-index"]

      # Find latest release channel still supported.
      avoid_phases = ["preview", "rc", "eol"].freeze
      valid_channels = index.select do |release|
        avoid_phases.exclude?(release["support-phase"])
      end
      latest_channel = valid_channels.max_by do |release|
        Version.new(release["channel-version"])
      end

      # Fetch the releases.json for that channel and find the latest release info.
      channel_page = Homebrew::Livecheck::Strategy.page_content(latest_channel["releases.json"])
      channel_json = JSON.parse(channel_page[:content])
      latest_release = channel_json["releases"].find do |release|
        release["release-version"] == channel_json["latest-release"]
      end

      # Get _oldest_ SDK version.
      latest_release["sdks"].map do |sdk|
        Version.new(sdk["version"])
      end.min.to_s
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a48ccb41aef44b23111a8c9af155a7d4ca687d12e693abdf16a460606b643534"
    sha256 cellar: :any,                 arm64_monterey: "d3b31cc177ef4abc05cbfc638bf10c5d208c727862698a65f2f1c1f200381134"
    sha256 cellar: :any,                 arm64_big_sur:  "7758478afea76d3736405674b37476b45d73d855de155df35049d4dd92dda4cb"
    sha256 cellar: :any,                 ventura:        "87c91d98f45df0407a2988272ec54016848ae6370dc0fed7a02444767f5f25db"
    sha256 cellar: :any,                 monterey:       "9e202396b41bcb8d45c857b9f4806a7907edf018ec4e14d8af1e3867f5d66320"
    sha256 cellar: :any,                 big_sur:        "015dca815eb4ea5b4a9a7160b79ad45e509ae6525e939f3a81d3985ec88533cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a75b5f8d7331b1db749735e6a8fb3f9dbfe6298c44fa0e8911d727e7195b8eb"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "icu4c"
  depends_on "openssl@1.1"

  uses_from_macos "llvm" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
    depends_on "lttng-ust"
  end

  # Upstream only directly supports and tests llvm/clang builds.
  # GCC builds have limited support via community.
  fails_with :gcc

  # Backport fix for error on aspnetcore version while building 'installer in tarball'.
  # TODO: Remove when available in release.
  # PR ref: https://github.com/dotnet/installer/pull/14938
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f206f7a45b330cce79e6bfe9116fccd93b0d3ed8/dotnet/aspnetcore-version.patch"
    sha256 "00103452e2f52831c04007f1b7f9fcd5ecddf0671943657104f0ac8d3a9ca613"
  end

  # Fix build failure on macOS due to missing bootstrap packages
  # Fix build failure on macOS ARM due to `osx-x64` override
  # Issue ref: https://github.com/dotnet/source-build/issues/2795
  patch :DATA

  def install
    if OS.linux?
      ENV.append_path "LD_LIBRARY_PATH", Formula["icu4c"].opt_lib
      ENV.append_to_cflags "-I#{Formula["krb5"].opt_include}"
    end

    # The source directory needs to be outside the installer directory
    (buildpath/"installer").install buildpath.children
    cd "installer" do
      system "./build.sh", "/p:ArcadeBuildTarball=true", "/p:TarballDir=#{buildpath}/sources"
    end

    cd "sources" do
      # Use our libunwind rather than the bundled one.
      inreplace "src/runtime/eng/SourceBuild.props",
                "/p:BuildDebPackage=false",
                "\\0 --cmakeargs -DCLR_CMAKE_USE_SYSTEM_LIBUNWIND=ON"

      # Rename patch fails on case-insensitive systems like macOS
      # TODO: Remove whenever patch is no longer used
      rename_patch = "0001-Rename-NuGet.Config-to-NuGet.config-to-account-for-a.patch"
      (Pathname("src/nuget-client/eng/source-build-patches")/rename_patch).unlink if OS.mac?

      # Work around build script getting stuck when running shutdown command on Linux
      # TODO: Try removing in the next release
      # Ref: https://github.com/dotnet/source-build/discussions/3105#discussioncomment-4373142
      inreplace "build.sh", "$CLI_ROOT/dotnet build-server shutdown", "" if OS.linux?

      prep_args = (OS.linux? && Hardware::CPU.intel?) ? [] : ["--bootstrap"]
      system "./prep.sh", *prep_args
      system "./build.sh", "--clean-while-building"

      libexec.mkpath
      tarball = Dir["artifacts/*/Release/dotnet-sdk-#{version}-*.tar.gz"].first
      system "tar", "-xzf", tarball, "--directory", libexec

      bash_completion.install "src/sdk/scripts/register-completions.bash" => "dotnet"
      zsh_completion.install "src/sdk/scripts/register-completions.zsh" => "_dotnet"
      man1.install Dir["src/sdk/documentation/manpages/sdk/*.1"]
    end

    doc.install Dir[libexec/"*.txt"]
    (bin/"dotnet").write_env_script libexec/"dotnet", DOTNET_ROOT: libexec
  end

  def caveats
    <<~EOS
      For other software to find dotnet you may need to set:
        export DOTNET_ROOT="#{opt_libexec}"
    EOS
  end

  test do
    target_framework = "net#{version.major_minor}"
    (testpath/"test.cs").write <<~EOS
      using System;

      namespace Homebrew
      {
        public class Dotnet
        {
          public static void Main(string[] args)
          {
            var joined = String.Join(",", args);
            Console.WriteLine(joined);
          }
        }
      }
    EOS
    (testpath/"test.csproj").write <<~EOS
      <Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
          <OutputType>Exe</OutputType>
          <TargetFrameworks>#{target_framework}</TargetFrameworks>
          <PlatformTarget>AnyCPU</PlatformTarget>
          <RootNamespace>Homebrew</RootNamespace>
          <PackageId>Homebrew.Dotnet</PackageId>
          <Title>Homebrew.Dotnet</Title>
          <Product>$(AssemblyName)</Product>
          <EnableDefaultCompileItems>false</EnableDefaultCompileItems>
        </PropertyGroup>
        <ItemGroup>
          <Compile Include="test.cs" />
        </ItemGroup>
      </Project>
    EOS
    system bin/"dotnet", "build", "--framework", target_framework, "--output", testpath, testpath/"test.csproj"
    assert_equal "#{testpath}/test.dll,a,b,c\n",
                 shell_output("#{bin}/dotnet run --framework #{target_framework} #{testpath}/test.dll a b c")
  end
end

__END__
diff --git a/src/SourceBuild/tarball/content/repos/installer.proj b/src/SourceBuild/tarball/content/repos/installer.proj
index f6803f4cf..da8caeda8 100644
--- a/src/SourceBuild/tarball/content/repos/installer.proj
+++ b/src/SourceBuild/tarball/content/repos/installer.proj
@@ -7,7 +7,7 @@

   <PropertyGroup>
     <OverrideTargetRid>$(TargetRid)</OverrideTargetRid>
-    <OverrideTargetRid Condition="'$(TargetOS)' == 'OSX'">osx-x64</OverrideTargetRid>
+    <OverrideTargetRid Condition="'$(TargetOS)' == 'OSX'">osx-$(Platform)</OverrideTargetRid>
     <OSNameOverride>$(OverrideTargetRid.Substring(0, $(OverrideTargetRid.IndexOf("-"))))</OSNameOverride>

     <RuntimeArg>--runtime-id $(OverrideTargetRid)</RuntimeArg>
@@ -28,7 +28,7 @@
     <BuildCommandArgs Condition="'$(TargetOS)' == 'Linux'">$(BuildCommandArgs) /p:AspNetCoreInstallerRid=linux-$(Platform)</BuildCommandArgs>
     <!-- core-sdk always wants to build portable on OSX and FreeBSD -->
     <BuildCommandArgs Condition="'$(TargetOS)' == 'FreeBSD'">$(BuildCommandArgs) /p:CoreSetupRid=freebsd-x64 /p:PortableBuild=true</BuildCommandArgs>
-    <BuildCommandArgs Condition="'$(TargetOS)' == 'OSX'">$(BuildCommandArgs) /p:CoreSetupRid=osx-x64</BuildCommandArgs>
+    <BuildCommandArgs Condition="'$(TargetOS)' == 'OSX'">$(BuildCommandArgs) /p:CoreSetupRid=osx-$(Platform)</BuildCommandArgs>
     <BuildCommandArgs Condition="'$(TargetOS)' == 'Linux'">$(BuildCommandArgs) /p:CoreSetupRid=$(TargetRid)</BuildCommandArgs>

     <!-- Consume the source-built Core-Setup and toolset. This line must be removed to source-build CLI without source-building Core-Setup first. -->
diff --git a/src/SourceBuild/tarball/content/repos/runtime.proj b/src/SourceBuild/tarball/content/repos/runtime.proj
index 59ea1d6fc..14d98fbb5 100644
--- a/src/SourceBuild/tarball/content/repos/runtime.proj
+++ b/src/SourceBuild/tarball/content/repos/runtime.proj
@@ -3,7 +3,7 @@

   <PropertyGroup>
     <OverrideTargetRid>$(TargetRid)</OverrideTargetRid>
-    <OverrideTargetRid Condition="'$(TargetOS)' == 'OSX'">osx-x64</OverrideTargetRid>
+    <OverrideTargetRid Condition="'$(TargetOS)' == 'OSX'">osx-$(Platform)</OverrideTargetRid>
     <OverrideTargetRid Condition="'$(TargetOS)' == 'FreeBSD'">freebsd-x64</OverrideTargetRid>
     <OverrideTargetRid Condition="'$(TargetOS)' == 'Windows_NT'">win-x64</OverrideTargetRid>

diff --git a/src/SourceBuild/tarball/content/eng/bootstrap/buildBootstrapPreviouslySB.csproj b/src/SourceBuild/tarball/content/eng/bootstrap/buildBootstrapPreviouslySB.csproj
index 9a00e2a48..27071417f 100644
--- a/src/SourceBuild/tarball/content/eng/bootstrap/buildBootstrapPreviouslySB.csproj
+++ b/src/SourceBuild/tarball/content/eng/bootstrap/buildBootstrapPreviouslySB.csproj
@@ -42,6 +42,17 @@
     <PackageDownload Include="runtime.linux-arm64.Microsoft.NETCore.ILDAsm" Version="[$(RuntimeLinuxX64MicrosoftNETCoreILDAsmVersion)]" />
     <PackageDownload Include="runtime.linux-arm64.Microsoft.NETCore.TestHost" Version="[$(RuntimeLinuxX64MicrosoftNETCoreTestHostVersion)]" />
     <PackageDownload Include="runtime.linux-arm64.runtime.native.System.IO.Ports" Version="[$(RuntimeLinuxX64RuntimeNativeSystemIOPortsVersion)]" />
+    <!-- Packages needed to bootstrap macOS -->
+    <PackageDownload Include="Microsoft.AspNetCore.App.Runtime.osx-x64" Version="[$(MicrosoftAspNetCoreAppRuntimeLinuxx64Version)]" />
+    <PackageDownload Include="Microsoft.AspNetCore.App.Runtime.osx-arm64" Version="[$(MicrosoftAspNetCoreAppRuntimeLinuxx64Version)]" />
+    <PackageDownload Include="Microsoft.NETCore.App.Crossgen2.osx-x64" Version="[$(MicrosoftNETCoreAppCrossgen2LinuxX64Version)]" />
+    <PackageDownload Include="Microsoft.NETCore.App.Crossgen2.osx-arm64" Version="[$(MicrosoftNETCoreAppCrossgen2LinuxX64Version)]" />
+    <PackageDownload Include="Microsoft.NETCore.App.Runtime.osx-x64" Version="[$(MicrosoftNETCoreAppRuntimeLinuxX64Version)]" />
+    <PackageDownload Include="Microsoft.NETCore.App.Runtime.osx-arm64" Version="[$(MicrosoftNETCoreAppRuntimeLinuxX64Version)]" />
+    <PackageDownload Include="runtime.osx-x64.Microsoft.NETCore.ILAsm" Version="[$(RuntimeLinuxX64MicrosoftNETCoreILAsmVersion)]" />
+    <PackageDownload Include="runtime.osx-arm64.Microsoft.NETCore.ILAsm" Version="[$(RuntimeLinuxX64MicrosoftNETCoreILAsmVersion)]" />
+    <PackageDownload Include="runtime.osx-x64.Microsoft.NETCore.ILDAsm" Version="[$(RuntimeLinuxX64MicrosoftNETCoreILDAsmVersion)]" />
+    <PackageDownload Include="runtime.osx-arm64.Microsoft.NETCore.ILDAsm" Version="[$(RuntimeLinuxX64MicrosoftNETCoreILDAsmVersion)]" />
   </ItemGroup>

   <Target Name="BuildBoostrapPreviouslySourceBuilt" AfterTargets="Restore">
