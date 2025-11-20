class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  license "MIT"
  version_scheme 1
  head "https://github.com/dotnet/dotnet.git", branch: "main"

  stable do
    # Source-build tag announced at https://github.com/dotnet/source-build/discussions
    version "9.0.8"
    url "https://github.com/dotnet/dotnet/archive/refs/tags/v9.0.109.tar.gz"
    sha256 "42fdfe3733884a3f6ceb3b428ff346ccb92f95010c447e27f3b164f70145730c"

    resource "release.json" do
      version "9.0.8"
      url "https://github.com/dotnet/dotnet/releases/download/v9.0.109/release.json"
      sha256 "328388103bf81072b638984d05b9dff5b6520a366d6448abbc7b985539deb8f4"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.\d{1,2})$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "343566caa1011741a13303014ceee74a91d807de9cd77f0438324939f9ff65bb"
    sha256 cellar: :any,                 arm64_sequoia: "0f23879804542b8e66c8521b87af973069165fc9379749083a25537aae9f94b1"
    sha256 cellar: :any,                 arm64_sonoma:  "5fbde0a48d63af42c31612f0384e009d879ee9af741d22fc5422d5df4b41d6b5"
    sha256 cellar: :any,                 arm64_ventura: "15e04bd0623d3981d7f19ccd7211e408113359382bd924ecf2df77c818d3c994"
    sha256 cellar: :any,                 ventura:       "cf89f9ff2627bbc1c5deb19df544de345e7b59f0b2f701dac30742795d0ddbe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1c0d7633d3c96929f02dc32132377889ee6585b9b9b6e115312434af40ca24f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22511e3d0ff36ec596f3cfdd8cfee282a67b4226f2916b94ebf162bc83c0f9c9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "brotli"
  depends_on "icu4c@77"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
    depends_on "grep" => :build # grep: invalid option -- P
  end

  on_linux do
    depends_on "libunwind"
    depends_on "lttng-ust"
  end

  conflicts_with cask: "dotnet-runtime"
  conflicts_with cask: "dotnet-runtime@preview"
  conflicts_with cask: "dotnet-sdk"
  conflicts_with cask: "dotnet-sdk@preview"

  def install
    if OS.mac?
      # Need GNU grep (Perl regexp support) to use release manifest rather than git repo
      ENV.prepend_path "PATH", Formula["grep"].libexec/"gnubin"

      # Avoid mixing CLT and Xcode.app when building CoreCLR component which can
      # cause undefined symbols, e.g. __swift_FORCE_LOAD_$_swift_Builtin_float
      ENV["SDKROOT"] = MacOS.sdk_path
    else
      icu4c_dep = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
      ENV.append_path "LD_LIBRARY_PATH", icu4c_dep.to_formula.opt_lib

      # Work around build script getting stuck when running shutdown command on Linux
      # TODO: Try removing in the next release
      # Ref: https://github.com/dotnet/source-build/discussions/3105#discussioncomment-4373142
      inreplace "build.sh", '"$CLI_ROOT/dotnet" build-server shutdown', ""
      inreplace "repo-projects/Directory.Build.targets",
                '"$(DotnetTool) build-server shutdown --vbcscompiler"',
                '"true"'
    end

    args = ["--clean-while-building", "--source-build", "--with-system-libs", "brotli+libunwind+rapidjson+zlib"]
    if build.stable?
      args += ["--release-manifest", "release.json"]
      odie "Update release.json resource!" if resource("release.json").version != version
      buildpath.install resource("release.json")
    end

    system "./prep-source-build.sh"
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
    # We switched to `assert_match` due to progress status ANSI codes in output.
    # TODO: Switch back to `assert_equal` once fixed in release.
    # Issue ref: https://github.com/dotnet/sdk/issues/44610
    assert_match "#{testpath}/test.dll,a,b,c\n", output

    # Test to avoid uploading broken Intel Sonoma bottle which has stack overflow on restore.
    # See https://github.com/Homebrew/homebrew-core/issues/197546
    resource "docfx" do
      url "https://github.com/dotnet/docfx/archive/refs/tags/v2.78.3.tar.gz"
      sha256 "d97142ff71bd84e200e6d121f09f57d28379a0c9d12cb58f23badad22cc5c1b7"
    end
    resource("docfx").stage do
      system bin/"dotnet", "restore", "src/docfx", "--disable-build-servers", "--no-cache"
    end
  end
end
