class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  url "https://github.com/dotnet/installer.git",
      tag:      "v6.0.110",
      revision: "ce0a42998a3d2a725f5bd08413b140d907f48177"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "7de1fed5e5f96e5a33b506bc67d7f42346fe3462692c555c7f8f77d2f574aeee"
    sha256 cellar: :any,                 arm64_monterey: "4462cce323287e601c885a71418ff2425e59c62364806775a6fb49c2bd5fdb91"
    sha256 cellar: :any,                 arm64_big_sur:  "341d025fed0a2bb01cf2199cc19aba069e90e83c9dd91c189818f68b12be8512"
    sha256 cellar: :any,                 ventura:        "3d16e46012f344be4370aa4cfa4a8c8f7d9e76250de42f9e7d8fd674b774a9f3"
    sha256 cellar: :any,                 monterey:       "b208c464e92f5dec6c9641a0a004a4c4f445e636ca4eee910866e5461784ebf7"
    sha256 cellar: :any,                 big_sur:        "e5cdb53c941e2f484c36ce4573cab3919b90a2164ba4960bb15aeb47da342baf"
    sha256 cellar: :any,                 catalina:       "68549d9d271924074783afaaf3257030c70d7f47511203d9badd3c43b62cff66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "645d857e3555c70c7475017f38d9556ead417f64e6903c4510fecaeb04741284"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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

  # Apple Silicon build fails due to latest dotnet-install.sh downloading x64 dotnet-runtime.
  # We work around the issue by using an older working copy of dotnet-install.sh script.
  # Bug introduced with https://github.com/dotnet/install-scripts/pull/314
  # TODO: Remove once script is fixed.
  # Issue ref: https://github.com/dotnet/install-scripts/issues/318
  resource "dotnet-install.sh" do
    url "https://raw.githubusercontent.com/dotnet/install-scripts/dac53157fcb7e02638507144bf5f8f019c1d23a8/src/dotnet-install.sh"
    sha256 "e96eabccea61bbbef3402e23f1889d385a6ae7ad84fe1d8f53f2507519ad86f7"
  end

  # Fixes race condition in MSBuild.
  # TODO: Remove with 6.0.3xx or later.
  resource "homebrew-msbuild-patch" do
    url "https://github.com/dotnet/msbuild/commit/64edb33a278d1334bd6efc35fecd23bd3af4ed48.patch?full_index=1"
    sha256 "5870bcdd12164668472094a2f9f1b73a4124e72ac99bbbe43028370be3648ccd"
  end

  # Fix build failure on macOS due to missing ILAsm/ILDAsm
  # Fix build failure on macOS ARM due to `osx-x64` override
  # Issue ref: https://github.com/dotnet/source-build/issues/2795
  patch :DATA

  def install
    ENV.append_path "LD_LIBRARY_PATH", Formula["icu4c"].opt_lib if OS.linux?

    (buildpath/".dotnet").install resource("dotnet-install.sh")
    (buildpath/"src/SourceBuild/tarball/patches/msbuild").install resource("homebrew-msbuild-patch")

    Dir.mktmpdir do |sourcedir|
      system "./build.sh", "/p:ArcadeBuildTarball=true", "/p:TarballDir=#{sourcedir}"
      cd sourcedir

      # Use our libunwind rather than the bundled one.
      inreplace "src/runtime/eng/SourceBuild.props",
                "/p:BuildDebPackage=false",
                "\\0 --cmakeargs -DCLR_CMAKE_USE_SYSTEM_LIBUNWIND=ON"

      # Fix Clang 15 error: definition of builtin function '__cpuid'.
      # TODO: Remove with v7.0.0 release which should have merged fix
      # Ref: https://github.com/dotnet/runtime/commit/992cf8c97cc71d4ca9a0a11e6604a6716ed4cefc
      inreplace "src/runtime/src/coreclr/vm/amd64/unixstubs.cpp",
                /^ *void (__cpuid|__cpuidex)\([^}]*}$/,
                "#if !__has_builtin(\\1)\n\\0\n#endif"

      # Fix missing macOS conditional for system unwind searching.
      # TODO: Remove with v7.0.0 release which should have merged fix
      # Ref: https://github.com/dotnet/runtime/commit/97c9a11e3e6ca68adf0c60155fa82ab3aae953a5
      inreplace "src/runtime/src/native/corehost/apphost/static/CMakeLists.txt",
                "if(CLR_CMAKE_USE_SYSTEM_LIBUNWIND)",
                "if(CLR_CMAKE_USE_SYSTEM_LIBUNWIND AND NOT CLR_CMAKE_TARGET_OSX)"

      # Work around arcade build failure with BSD `sed` due to non-compatible `-i`.
      # TODO: Remove with v7.0.0 release which has removed GNU `sed -i` usage
      # Ref: https://github.com/dotnet/arcade/commit/b8007eed82adabd50c604a9849277a6e7be5c971
      inreplace "src/arcade/eng/SourceBuild.props", "\"sed -i ", "\"sed -i.bak " if OS.mac?

      # Workaround for error MSB4018 while building 'installer in tarball' due
      # to trying to find aspnetcore-runtime-internal v6.0.0 rather than current.
      # TODO: Remove when packaging is fixed
      # Issue ref: https://github.com/dotnet/source-build/issues/2795
      inreplace "src/installer/src/redist/targets/GenerateLayout.targets",
                "$(MicrosoftAspNetCoreAppRuntimePackageVersion)",
                "$(MicrosoftAspNetCoreAppRuntimewinx64PackageVersion)"

      # Rename patch fails on case-insensitive systems like macOS
      # TODO: Remove whenever patch is no longer used
      rename_patch = "0001-Rename-NuGet.Config-to-NuGet.config-to-account-for-a.patch"
      (Pathname.pwd/"src/nuget-client/eng/source-build-patches"/rename_patch).unlink if OS.mac?

      system "./prep.sh", "--bootstrap"
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
index 712d7cd14..31d54866c 100644
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
     <BuildCommandArgs Condition="'$(TargetOS)' == 'Linux'">$(BuildCommandArgs) /p:AspNetCoreSharedFxInstallerRid=linux-$(Platform)</BuildCommandArgs>
     <!-- core-sdk always wants to build portable on OSX and FreeBSD -->
     <BuildCommandArgs Condition="'$(TargetOS)' == 'FreeBSD'">$(BuildCommandArgs) /p:CoreSetupRid=freebsd-x64 /p:PortableBuild=true</BuildCommandArgs>
-    <BuildCommandArgs Condition="'$(TargetOS)' == 'OSX'">$(BuildCommandArgs) /p:CoreSetupRid=osx-x64</BuildCommandArgs>
+    <BuildCommandArgs Condition="'$(TargetOS)' == 'OSX'">$(BuildCommandArgs) /p:CoreSetupRid=osx-$(Platform)</BuildCommandArgs>
     <BuildCommandArgs Condition="'$(TargetOS)' == 'Linux'">$(BuildCommandArgs) /p:CoreSetupRid=$(TargetRid)</BuildCommandArgs>

     <!-- Consume the source-built Core-Setup and toolset. This line must be removed to source-build CLI without source-building Core-Setup first. -->
diff --git a/src/SourceBuild/tarball/content/repos/runtime.proj b/src/SourceBuild/tarball/content/repos/runtime.proj
index f3ed143f8..2c62d6854 100644
--- a/src/SourceBuild/tarball/content/repos/runtime.proj
+++ b/src/SourceBuild/tarball/content/repos/runtime.proj
@@ -3,7 +3,7 @@

   <PropertyGroup>
     <OverrideTargetRid>$(TargetRid)</OverrideTargetRid>
-    <OverrideTargetRid Condition="'$(TargetOS)' == 'OSX'">osx-x64</OverrideTargetRid>
+    <OverrideTargetRid Condition="'$(TargetOS)' == 'OSX'">osx-$(Platform)</OverrideTargetRid>
     <OverrideTargetRid Condition="'$(TargetOS)' == 'FreeBSD'">freebsd-x64</OverrideTargetRid>
     <OverrideTargetRid Condition="'$(TargetOS)' == 'Windows_NT'">win-x64</OverrideTargetRid>

diff --git a/src/SourceBuild/tarball/content/scripts/bootstrap/buildBootstrapPreviouslySB.csproj b/src/SourceBuild/tarball/content/scripts/bootstrap/buildBootstrapPreviouslySB.csproj
index 14921a48f..3a34e8749 100644
--- a/src/SourceBuild/tarball/content/scripts/bootstrap/buildBootstrapPreviouslySB.csproj
+++ b/src/SourceBuild/tarball/content/scripts/bootstrap/buildBootstrapPreviouslySB.csproj
@@ -33,6 +33,14 @@
     <!-- There's no nuget package for runtime.linux-musl-x64.runtime.native.System.IO.Ports
     <PackageReference Include="runtime.linux-musl-x64.runtime.native.System.IO.Ports" Version="$(RuntimeLinuxX64RuntimeNativeSystemIOPortsVersion)" />
     -->
+    <PackageReference Include="runtime.osx-arm64.Microsoft.NETCore.ILAsm" Version="$(RuntimeLinuxX64MicrosoftNETCoreILAsmVersion)" />
+    <PackageReference Include="runtime.osx-arm64.Microsoft.NETCore.ILDAsm" Version="$(RuntimeLinuxX64MicrosoftNETCoreILDAsmVersion)" />
+    <PackageReference Include="runtime.osx-arm64.Microsoft.NETCore.TestHost" Version="$(RuntimeLinuxX64MicrosoftNETCoreTestHostVersion)" />
+    <PackageReference Include="runtime.osx-arm64.runtime.native.System.IO.Ports" Version="$(RuntimeLinuxX64RuntimeNativeSystemIOPortsVersion)" />
+    <PackageReference Include="runtime.osx-x64.Microsoft.NETCore.ILAsm" Version="$(RuntimeLinuxX64MicrosoftNETCoreILAsmVersion)" />
+    <PackageReference Include="runtime.osx-x64.Microsoft.NETCore.ILDAsm" Version="$(RuntimeLinuxX64MicrosoftNETCoreILDAsmVersion)" />
+    <PackageReference Include="runtime.osx-x64.Microsoft.NETCore.TestHost" Version="$(RuntimeLinuxX64MicrosoftNETCoreTestHostVersion)" />
+    <PackageReference Include="runtime.osx-x64.runtime.native.System.IO.Ports" Version="$(RuntimeLinuxX64RuntimeNativeSystemIOPortsVersion)" />
   </ItemGroup>

   <Target Name="BuildBoostrapPreviouslySourceBuilt" AfterTargets="Restore">
