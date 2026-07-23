class DotnetAT8 < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  # Source-build tag announced at https://github.com/dotnet/source-build/discussions
  url "https://github.com/dotnet/dotnet/archive/refs/tags/v8.0.129.tar.gz"
  sha256 "5141b7551a98f742543c21af3ffe32e3ff83d1f55754de024f23bb2f9e7a277f"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(8(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "24e6c92bab187af204c51a2178507339051b030b88b95488a45c0232dc1ce1f1"
    sha256 cellar: :any, arm64_sequoia: "94ff7db29edf2063351a5cef7f1a30d7c7e962383ad678a48143d7a07d8c4c64"
    sha256 cellar: :any, arm64_sonoma:  "e9862c724d4101ec5f395e3e12d129374333cfb67733b5837326f2c47137ffe1"
    sha256 cellar: :any, sonoma:        "42f8cc6e4a2a4bb40c7d0039242bdaf18757a6680da9f5ae79bc20b7099f9a66"
    sha256 cellar: :any, arm64_linux:   "0d5d9a6bd5ea80e64c5e42f271b53fc090cecab984bc0befa5c0f72556a57dce"
    sha256 cellar: :any, x86_64_linux:  "9537111b7ccf5bcca8f49e35c96bd6b3ecad47f35aefbf4e9d59141b919d8c9e"
  end

  keg_only :versioned_formula

  # https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core#lifecycle
  deprecate! date: "2026-11-10", because: :unsupported
  disable! date: "2027-11-10", because: :unsupported

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "krb5"

  on_macos do
    depends_on "grep" => :build # grep: invalid option -- P
    depends_on "llvm@20" => :build if DevelopmentTools.clang_build_version >= 2100
  end

  on_linux do
    depends_on "libunwind"
    depends_on "lttng-ust"
    depends_on "zlib-ng-compat"

    on_intel do
      depends_on "llvm" => :build

      fails_with :gcc do
        cause "Fatal error. Internal CLR error"
      end
    end
  end

  resource "release.json" do
    url "https://github.com/dotnet/dotnet/releases/download/v8.0.129/release.json"
    sha256 "bc2dce6de85e09174848b2f786b62e909f30b2ce0d56d2e89e61aa28a61b5f2b"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "Update release.json resource!" if resource("release.json").version != version
    buildpath.install resource("release.json")

    # .NET built with Apple Clang 2100 (based on LLVM 21) sporadically crashes
    if DevelopmentTools.clang_build_version >= 2100
      ENV["CC"] = formula_opt_bin("llvm@20")/"clang"
      ENV["CXX"] = formula_opt_bin("llvm@20")/"clang++"
      ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include"
    end

    # Make sure CoreCLR builds with our compiler shims
    ENV["CLR_CC"] = which(ENV.cc)
    ENV["CLR_CXX"] = which(ENV.cxx)

    if OS.mac?
      # Need GNU grep (Perl regexp support) to use release manifest rather than git repo
      ENV.prepend_path "PATH", Formula["grep"].libexec/"gnubin"

      # Avoid mixing CLT and Xcode.app when building CoreCLR component which can
      # cause undefined symbols, e.g. __swift_FORCE_LOAD_$_swift_Builtin_float
      ENV["SDKROOT"] = MacOS.sdk_for_formula(self).path

      # Deparallelize to reduce chances of missing PDBs
      ENV.deparallelize
      # Avoid failing on missing PDBs as unable to build bottle on all runners in current state
      # Issue ref: https://github.com/dotnet/source-build/issues/4150
      inreplace "build.proj", /\bFailOnMissingPDBs="true"/, 'FailOnMissingPDBs="false"'

      # Disable crossgen2 optimization in ASP.NET Core to work around build failure trying to find tool.
      # Microsoft.AspNetCore.App.Runtime.csproj(445,5): error : Could not find crossgen2 tools/crossgen2
      inreplace "src/aspnetcore/src/Framework/App.Runtime/src/Microsoft.AspNetCore.App.Runtime.csproj",
                "<CrossgenOutput Condition=\" '$(TargetArchitecture)' == 's390x'",
                "<CrossgenOutput Condition=\" '$(TargetOsName)' == 'osx'"
    else
      icu4c_dep = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
      ENV.append_path "LD_LIBRARY_PATH", icu4c_dep.to_formula.opt_lib

      # Use our libunwind rather than the bundled one.
      inreplace "src/runtime/eng/SourceBuild.props",
                "--outputrid $(TargetRid)",
                "\\0 --cmakeargs -DCLR_CMAKE_USE_SYSTEM_LIBUNWIND=ON"

      # Work around build script getting stuck when running shutdown command on Linux
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
      system "./build.sh", "--clean-while-building", "--online", "--release-manifest", "release.json"
    end

    libexec.mkpath
    tarball = buildpath.glob("artifacts/*/Release/dotnet-sdk-*.tar.gz").first
    system "tar", "--extract", "--file", tarball, "--directory", libexec
    doc.install libexec.glob("*.txt")
    (bin/"dotnet").write_env_script libexec/"dotnet", DOTNET_ROOT: libexec

    bash_completion.install "src/sdk/scripts/register-completions.bash" => "dotnet"
    zsh_completion.install "src/sdk/scripts/register-completions.zsh" => "_dotnet"
    man1.install Utils::Gzip.compress(*buildpath.glob("src/sdk/documentation/manpages/sdk/*.1"))
    man7.install Utils::Gzip.compress(*buildpath.glob("src/sdk/documentation/manpages/sdk/*.7"))
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
    output = shell_output("#{bin}/dotnet run --framework #{target_framework} #{testpath}/test.dll a b c")
    assert_equal "#{testpath}/test.dll,a,b,c\n", output

    # Test to avoid uploading broken Intel Sonoma bottle which has stack overflow on restore.
    # See https://github.com/Homebrew/homebrew-core/issues/197546
    resource "docfx" do
      url "https://github.com/dotnet/docfx/archive/refs/tags/v2.78.4.tar.gz"
      sha256 "255f71f4a6fc7b9ffd0c598d0eba11630dc01262f1fa45ec4f1794508f7033cf"
    end
    resource("docfx").stage do
      msbuild_args = ["-p:TargetFrameworks=net8.0"]
      system bin/"dotnet", "restore", "src/docfx", "--disable-build-servers", "--no-cache", *msbuild_args
    end
  end
end
