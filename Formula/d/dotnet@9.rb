class DotnetAT9 < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  # Source-build tag announced at https://github.com/dotnet/source-build/discussions
  url "https://github.com/dotnet/dotnet/archive/refs/tags/v9.0.121.tar.gz"
  sha256 "81bb1b6e59922f49c4155fb3b4bd17eed024e8df613ef4b6cff88c027a42edc0"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(9(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3d85c00fe01dac80891e46d11d1334ae1d5af153469546e7748ed0f6688a797a"
    sha256 cellar: :any, arm64_sequoia: "6631fa727eed0c24215677b3f2eba84b0f4eebb1e283e9e04995e88b118c8a20"
    sha256 cellar: :any, arm64_sonoma:  "a394c4e465e56ec121901460a3f5d9116fe13940f285ed431a81d20398bb0719"
    sha256 cellar: :any, arm64_linux:   "7bb05fe3a5bbb1ce1c19d845dfbd7ad59660580370ba084e1aa0e6abfc26f541"
    sha256               x86_64_linux:  "c74ee929da237116149e39e8addc5bd690095f95552759a0007398a995f31912"
  end

  keg_only :versioned_formula

  # https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core#lifecycle
  deprecate! date: "2026-11-10", because: :unsupported
  disable! date: "2027-11-10", because: :unsupported

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "brotli"
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
        cause "Illegal instruction when running crossgen2"
      end
    end
  end

  resource "release.json" do
    url "https://github.com/dotnet/dotnet/releases/download/v9.0.121/release.json"
    sha256 "24e6a99a2f7401054ff0b9445c4a205bc32481b320a821545312eea7e83a0d22"

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
      ENV.prepend_path "PATH", formula_opt_libexec("grep")/"gnubin"

      # Avoid mixing CLT and Xcode.app when building CoreCLR component which can
      # cause undefined symbols, e.g. __swift_FORCE_LOAD_$_swift_Builtin_float
      ENV["SDKROOT"] = MacOS.sdk_for_formula(self).path
    else
      icu4c_dep = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
      ENV.append_path "LD_LIBRARY_PATH", icu4c_dep.to_formula.opt_lib

      # Work around build script getting stuck when running shutdown command on Linux
      # Ref: https://github.com/dotnet/source-build/discussions/3105#discussioncomment-4373142
      inreplace "build.sh", '"$CLI_ROOT/dotnet" build-server shutdown', ""
      inreplace "repo-projects/Directory.Build.targets",
                '"$(DotnetTool) build-server shutdown --vbcscompiler"',
                '"true"'
    end

    args = %w[
      --clean-while-building
      --release-manifest release.json
      --source-build
      --with-system-libs brotli+libunwind+rapidjson+zlib
    ]

    system "./prep-source-build.sh"
    if OS.mac?
      # MSBuild hardcodes `/tmp` for its sockets, which the build sandbox denies, so prefer a short `TMPDIR`.
      # Below 38 characters, even its longest socket name (66) fits macOS's 103-byte socket path limit.
      # https://github.com/Homebrew/brew/issues/23934
      inreplace "src/msbuild/src/Shared/NamedPipeUtil.cs",
                'Path.Combine("/tmp", pipeName)',
                'Path.Combine(Path.GetTempPath().Length < 38 ? Path.GetTempPath() : "/tmp", pipeName)'
      # Avoid worker nodes, which the unpatched bootstrap MSBuild cannot reach
      system ".dotnet/dotnet", "build", "src/msbuild/src/MSBuild/MSBuild.csproj", "--configuration", "Release",
             "-maxcpucount:1"
      # Replace the bootstrap SDK's MSBuild with the patched one
      cp Dir["src/msbuild/artifacts/bin/MSBuild/Release/net*/{MSBuild,Microsoft.Build*}.dll"],
         Dir[".dotnet/sdk/*"].first
      # `build.sh` builds MSBuild again into the same directory
      rm_r "src/msbuild/artifacts"
    end
    # The sandbox also denies the Roslyn compiler server's `/tmp` socket, so compile without it
    ENV["UseSharedCompilation"] = "false" if OS.mac?
    # We unset "CI" environment variable to work around aspire build failure
    # error MSB4057: The target "GitInfo" does not exist in the project.
    # Ref: https://github.com/Homebrew/homebrew-core/pull/154584#issuecomment-1815575483
    with_env(CI: nil) do
      system "./build.sh", *args
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
    <<~CAVEATS
      For other software to find dotnet you may need to set:
        export DOTNET_ROOT="#{opt_libexec}"
    CAVEATS
  end

  test do
    target_framework = "net#{version.major_minor}"

    (testpath/"test.cs").write <<~CS
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
    CS

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
      system bin/"dotnet", "restore", "src/docfx", "--disable-build-servers", "--no-cache"
    end
  end
end
