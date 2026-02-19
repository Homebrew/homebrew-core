class DotnetAT6 < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  # Source-build tag announced at https://github.com/dotnet/source-build/discussions
  url "https://github.com/dotnet/installer.git",
      tag:      "v6.0.136",
      revision: "d638663530d923adbe0442604b7a6562127321e9"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "82ed4db4fccf6439ffd03275abba8ef8801185780eea042f7f2f445647b2058a"
    sha256 cellar: :any,                 arm64_sequoia: "17a1b695a3859a75a1379c9ff5aa044a1e0d4517d27454ab699a88992ed4054c"
    sha256 cellar: :any,                 arm64_sonoma:  "3842fe4efbd79ee741fddf3e27f33e9d3a14533c4a7a8b27ebc9fa6423906cf7"
    sha256 cellar: :any,                 sonoma:        "10a9849193aa400d0542751ba82dfc7c03721f01c38a143fcf7f7bdd1e762349"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "194441cf808cb24d14994881e2f30fd0bce8f28375430f4c8c75881cc801116f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a66fa701d2a875604a253d37f89772910bb6aae1ed402abe5c52444f62264ecf"
  end

  keg_only :versioned_formula

  # https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core#lifecycle
  deprecate! date: "2024-11-12", because: :unsupported
  disable! date: "2025-11-12", because: :unsupported

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "icu4c@77"
  depends_on "openssl@3"

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
  # Issue ref: https://github.com/dotnet/install-scripts/issues/318
  resource "dotnet-install.sh" do
    url "https://raw.githubusercontent.com/dotnet/install-scripts/dac53157fcb7e02638507144bf5f8f019c1d23a8/src/dotnet-install.sh"
    sha256 "e96eabccea61bbbef3402e23f1889d385a6ae7ad84fe1d8f53f2507519ad86f7"
  end

  # Fixes race condition in MSBuild.
  resource "homebrew-msbuild-patch" do
    url "https://github.com/dotnet/msbuild/commit/64edb33a278d1334bd6efc35fecd23bd3af4ed48.patch?full_index=1"
    sha256 "5870bcdd12164668472094a2f9f1b73a4124e72ac99bbbe43028370be3648ccd"
  end

  # Fix build failure on macOS due to missing bootstrap packages
  # Fix build failure on macOS ARM due to `osx-x64` override
  # Issue ref: https://github.com/dotnet/source-build/issues/2795
  patch :DATA

  # Backport fix to build with Clang 19
  # Ref: https://github.com/dotnet/runtime/commit/043ae8c50dbe1c7377cf5ad436c5ac1c226aef79
  def clang19_patch
    <<~PATCH
      diff --git a/src/coreclr/vm/comreflectioncache.hpp b/src/coreclr/vm/comreflectioncache.hpp
      index 08d173e61648c6ebb98a4d7323b30d40ec351d94..12db55251d80d24e3765a8fbe6e3b2d24a12f767 100644
      --- a/src/coreclr/vm/comreflectioncache.hpp
      +++ b/src/coreclr/vm/comreflectioncache.hpp
      @@ -26,6 +26,7 @@ template <class Element, class CacheType, int CacheSize> class ReflectionCache

           void Init();

      +#ifndef DACCESS_COMPILE
           BOOL GetFromCache(Element *pElement, CacheType& rv)
           {
               CONTRACTL
      @@ -102,6 +103,7 @@ template <class Element, class CacheType, int CacheSize> class ReflectionCache
               AdjustStamp(TRUE);
               this->LeaveWrite();
           }
      +#endif // !DACCESS_COMPILE

       private:
           // Lock must have been taken before calling this.
      @@ -141,6 +143,7 @@ template <class Element, class CacheType, int CacheSize> class ReflectionCache
               return CacheSize;
           }

      +#ifndef DACCESS_COMPILE
           void AdjustStamp(BOOL hasWriterLock)
           {
               CONTRACTL
      @@ -170,6 +173,7 @@ template <class Element, class CacheType, int CacheSize> class ReflectionCache
               if (!hasWriterLock)
                   this->LeaveWrite();
           }
      +#endif // !DACCESS_COMPILE

           void UpdateHashTable(SIZE_T hash, int slot)
           {
    PATCH
  end

  # Backport fix to build with Xcode 16 (copying unixasmmacrosarm64.inc to unixasmmacrosamd64.inc for Intel macOS)
  # Ref: https://github.com/dotnet/runtime/commit/562efd6824762dd0c1826cc99e006ad34a7e9e85
  def xcode16_patch
    <<~'PATCH'
      diff --git a/src/coreclr/pal/inc/unixasmmacrosamd64.inc b/src/coreclr/pal/inc/unixasmmacrosamd64.inc
      index 976cc825f2eb4..4997e18b39858 100644
      --- a/src/coreclr/pal/inc/unixasmmacrosamd64.inc
      +++ b/src/coreclr/pal/inc/unixasmmacrosamd64.inc
      @@ -17,7 +17,12 @@
       .endm

       .macro PATCH_LABEL Name
      +#if defined(__APPLE__)
      +        .alt_entry C_FUNC(\Name)
      +        .private_extern C_FUNC(\Name)
      +#else
               .global C_FUNC(\Name)
      +#endif
       C_FUNC(\Name):
       .endm

      diff --git a/src/coreclr/pal/inc/unixasmmacrosarm64.inc b/src/coreclr/pal/inc/unixasmmacrosarm64.inc
      index 976cc825f2eb4..4997e18b39858 100644
      --- a/src/coreclr/pal/inc/unixasmmacrosarm64.inc
      +++ b/src/coreclr/pal/inc/unixasmmacrosarm64.inc
      @@ -17,7 +17,12 @@
       .endm

       .macro PATCH_LABEL Name
      +#if defined(__APPLE__)
      +        .alt_entry C_FUNC(\Name)
      +        .private_extern C_FUNC(\Name)
      +#else
               .global C_FUNC(\Name)
      +#endif
       C_FUNC(\Name):
       .endm

      diff --git a/src/coreclr/vm/arm64/asmhelpers.S b/src/coreclr/vm/arm64/asmhelpers.S
      index ebfefd693f074..48c91e65a098d 100644
      --- a/src/coreclr/vm/arm64/asmhelpers.S
      +++ b/src/coreclr/vm/arm64/asmhelpers.S
      @@ -176,8 +176,7 @@ NESTED_END ThePreStub, _TEXT

       LEAF_ENTRY ThePreStubPatch, _TEXT
           nop
      -.globl C_FUNC(ThePreStubPatchLabel)
      -C_FUNC(ThePreStubPatchLabel):
      +PATCH_LABEL ThePreStubPatchLabel
           ret lr
       LEAF_END ThePreStubPatch, _TEXT

      @@ -607,8 +606,12 @@ NESTED_END ResolveWorkerAsmStub, _TEXT
       #ifdef FEATURE_READYTORUN

       NESTED_ENTRY DelayLoad_MethodCall_FakeProlog, _TEXT, NoHandler
      -C_FUNC(DelayLoad_MethodCall):
      +#if defined(__APPLE__)
      +    .alt_entry C_FUNC(DelayLoad_MethodCall)
      +#endif
           .global C_FUNC(DelayLoad_MethodCall)
      +C_FUNC(DelayLoad_MethodCall):
      +
           PROLOG_WITH_TRANSITION_BLOCK

           add x0, sp, #__PWTB_TransitionBlock // pTransitionBlock
      @@ -627,8 +630,11 @@ NESTED_END DelayLoad_MethodCall_FakeProlog, _TEXT

       .macro DynamicHelper frameFlags, suffix
       NESTED_ENTRY DelayLoad_Helper\suffix\()_FakeProlog, _TEXT, NoHandler
      -C_FUNC(DelayLoad_Helper\suffix):
      +#if defined(__APPLE__)
      +    .alt_entry C_FUNC(DelayLoad_Helper\suffix)
      +#endif
           .global C_FUNC(DelayLoad_Helper\suffix)
      +C_FUNC(DelayLoad_Helper\suffix):

           PROLOG_WITH_TRANSITION_BLOCK

    PATCH
  end

  def install
    if OS.linux?
      icu4c = deps.map(&:to_formula).find { |f| f.name.match?(/^icu4c@\d+$/) }
      ENV.append_path "LD_LIBRARY_PATH", icu4c.opt_lib if OS.linux?
      ENV.append_to_cflags "-I#{Formula["krb5"].opt_include}"
      ENV.append_to_cflags "-I#{Formula["zlib"].opt_include}"
    end

    (buildpath/".dotnet").install resource("dotnet-install.sh")
    (buildpath/"src/SourceBuild/tarball/patches/msbuild").install resource("homebrew-msbuild-patch")
    (buildpath/"src/SourceBuild/tarball/patches/runtime/clang19.patch").write clang19_patch
    (buildpath/"src/SourceBuild/tarball/patches/runtime/xcode16.patch").write xcode16_patch if OS.mac?

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

      # Fix Clang 15 error: definition of builtin function '__cpuid'.
      # Ref: https://github.com/dotnet/runtime/commit/992cf8c97cc71d4ca9a0a11e6604a6716ed4cefc
      inreplace "src/runtime/src/coreclr/vm/amd64/unixstubs.cpp",
                /^ *void (__cpuid|__cpuidex)\([^}]*}$/,
                "#if !__has_builtin(\\1)\n\\0\n#endif"

      # Fix missing macOS conditional for system unwind searching.
      # Ref: https://github.com/dotnet/runtime/commit/97c9a11e3e6ca68adf0c60155fa82ab3aae953a5
      inreplace "src/runtime/src/native/corehost/apphost/static/CMakeLists.txt",
                "if(CLR_CMAKE_USE_SYSTEM_LIBUNWIND)",
                "if(CLR_CMAKE_USE_SYSTEM_LIBUNWIND AND NOT CLR_CMAKE_TARGET_OSX)"

      # Work around arcade build failure with BSD `sed` due to non-compatible `-i`.
      # Ref: https://github.com/dotnet/arcade/commit/b8007eed82adabd50c604a9849277a6e7be5c971
      inreplace "src/arcade/eng/SourceBuild.props", "\"sed -i ", "\"sed -i.bak " if OS.mac?

      # Rename patch fails on case-insensitive systems like macOS
      rename_patch = "0001-Rename-NuGet.Config-to-NuGet.config-to-account-for-a.patch"
      (Pathname("src/nuget-client/eng/source-build-patches")/rename_patch).unlink if OS.mac?

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
    <<~TEXT
      For other software to find dotnet you may need to set:
        export DOTNET_ROOT="#{opt_libexec}"
    TEXT
  end

  test do
    target_framework = "net#{version.major_minor}"
    (testpath/"test.cs").write <<~CSHARP
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
    CSHARP

    (testpath/"test.csproj").write <<~XML
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
    XML

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
