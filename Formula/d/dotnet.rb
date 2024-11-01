class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  # Source-build tag announced at https://github.com/dotnet/source-build/discussions
  url "https://github.com/dotnet/dotnet.git",
      tag:      "v8.0.8",
      revision: "e78e8a64f20e61e1fea4f24afca66ad1dc56285f"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ea299c5472d772f5bf8a8a1dce36ead86414113fcc2475b2f5a542657d2629b4"
    sha256 cellar: :any,                 arm64_sonoma:  "c0978f5c891ed544c589e6ed3ca0391abf2a93d85fb59d562d07a02b295a8a2f"
    sha256 cellar: :any,                 arm64_ventura: "93939e3425948fcf22baebd4ec5a03f67d47305e5d6f928d47cb70841d23d3f4"
    sha256 cellar: :any,                 sonoma:        "b234644e4bcc96cf9d378ac2b229de39c7110f7f884e1192727059495fdcfcc8"
    sha256 cellar: :any,                 ventura:       "aeaeb3a3e629b3c5d406e3b0bcf46b2ffcf96e6a7cc132dcbad0dcb6770abd73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cb8586bb9259586a60fbbdc50bf4cc727646c4f8c8e28323907d8dd10c5a948"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.13" => :build
  depends_on "icu4c@76"
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_sonoma do
    depends_on xcode: :build if DevelopmentTools.clang_build_version == 1600
  end

  on_linux do
    depends_on "libunwind"
    depends_on "lttng-ust"
  end

  # Upstream only directly supports and tests llvm/clang builds.
  # GCC builds have limited support via community.
  fails_with :gcc

  # Backport fix for error loading BuildXL service index
  patch do
    url "https://github.com/dotnet/dotnet/commit/18b5c7e1b125468f483a697ba8809c0a2412a762.patch?full_index=1"
    sha256 "76ede810166cf718fe430a8b155da07ca245ec9174b73b3471baf413bbd42460"
  end

  # Backport fix to build with Xcode 16
  patch do
    url "https://github.com/dotnet/runtime/commit/562efd6824762dd0c1826cc99e006ad34a7e9e85.patch?full_index=1"
    sha256 "435002246227064be19db8065b945e94565b59362e75a72ee6d6322a25baa832"
    directory "src/runtime"
  end

  # Backport fix to build with Clang 19
  # Ref: https://github.com/dotnet/runtime/commit/043ae8c50dbe1c7377cf5ad436c5ac1c226aef79
  patch :DATA

  def install
    # Currently, we are using `prep.sh` to pull the dotnet SDK, which might not be up to date.
    # Thus, updating the to use the latest 8.0.1xx SDK version, as only 6.0.1xx and 8.0.1xx are supported,
    # see in https://github.com/dotnet/source-build?tab=readme-ov-file#support
    inreplace "global.json", "8.0.107", "8.0.110"

    if OS.mac?
      # Deparallelize to reduce chances of missing PDBs
      ENV.deparallelize
      # Avoid failing on missing PDBs as unable to build bottle on all runners in current state
      # Issue ref: https://github.com/dotnet/source-build/issues/4150
      inreplace "build.proj", /\bFailOnMissingPDBs="true"/, 'FailOnMissingPDBs="false"'

      # Disable crossgen2 optimization in ASP.NET Core to work around build failure trying to find tool.
      # Microsoft.AspNetCore.App.Runtime.csproj(445,5): error : Could not find crossgen2 tools/crossgen2
      # TODO: Try to remove in future .NET 8 release or when macOS is officially supported in .NET 9
      inreplace "src/aspnetcore/src/Framework/App.Runtime/src/Microsoft.AspNetCore.App.Runtime.csproj",
                "<CrossgenOutput Condition=\" '$(TargetArchitecture)' == 's390x'",
                "<CrossgenOutput Condition=\" '$(TargetOsName)' == 'osx'"
    else
      icu4c_dep = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
      ENV.append_path "LD_LIBRARY_PATH", icu4c_dep.to_formula.opt_lib
      ENV.append_to_cflags "-I#{Formula["krb5"].opt_include}"
      ENV.append_to_cflags "-I#{Formula["zlib"].opt_include}"

      # Use our libunwind rather than the bundled one.
      inreplace "src/runtime/eng/SourceBuild.props",
                "--outputrid $(TargetRid)",
                "\\0 --cmakeargs -DCLR_CMAKE_USE_SYSTEM_LIBUNWIND=ON"

      # Work around build script getting stuck when running shutdown command on Linux
      # TODO: Try removing in the next release
      # Ref: https://github.com/dotnet/source-build/discussions/3105#discussioncomment-4373142
      inreplace "build.sh", '"$CLI_ROOT/dotnet" build-server shutdown', ""
      inreplace "repo-projects/Directory.Build.targets",
                '<Exec Command="$(DotnetToolCommand) build-server shutdown" />',
                ""
    end

    system "./prep.sh"
    # We unset "CI" environment variable to work around aspire build failure
    # error MSB4057: The target "GitInfo" does not exist in the project.
    # Ref: https://github.com/Homebrew/homebrew-core/pull/154584#issuecomment-1815575483
    with_env(CI: nil) do
      system "./build.sh", "--clean-while-building", "--online"
    end

    libexec.mkpath
    tarball = Dir["artifacts/*/Release/dotnet-sdk-*.tar.gz"].first
    system "tar", "-xzf", tarball, "--directory", libexec
    doc.install Dir[libexec/"*.txt"]
    (bin/"dotnet").write_env_script libexec/"dotnet", DOTNET_ROOT: libexec

    bash_completion.install "src/sdk/scripts/register-completions.bash" => "dotnet"
    zsh_completion.install "src/sdk/scripts/register-completions.zsh" => "_dotnet"
    man1.install Dir["src/sdk/documentation/manpages/sdk/*.1"]
    man7.install Dir["src/sdk/documentation/manpages/sdk/*.7"]
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
diff --git a/src/runtime/src/coreclr/vm/comreflectioncache.hpp b/src/runtime/src/coreclr/vm/comreflectioncache.hpp
index 08d173e61648c6ebb98a4d7323b30d40ec351d94..12db55251d80d24e3765a8fbe6e3b2d24a12f767 100644
--- a/src/runtime/src/coreclr/vm/comreflectioncache.hpp
+++ b/src/runtime/src/coreclr/vm/comreflectioncache.hpp
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
