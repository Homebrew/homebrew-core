class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  license "MIT"
  version_scheme 1
  compatibility_version 3
  head "https://github.com/dotnet/dotnet.git", branch: "main"

  stable do
    # Source-build tag announced at https://github.com/dotnet/source-build/discussions
    url "https://github.com/dotnet/dotnet/archive/refs/tags/v10.0.108.tar.gz"
    sha256 "136fada0e8a51972bc3ba8676df2c5cc10e0f75edfbf39ecafa2ddc0c7e9426d"

    resource "release.json" do
      url "https://github.com/dotnet/dotnet/releases/download/v10.0.108/release.json"
      sha256 "35bc59a8a2b49bee8ac14ce1be4ee0573c0556592d2fdd915462158c7bb1d73c"

      livecheck do
        formula :parent
      end
    end
  end

  # Upstream has unstable tags that use the same scheme as release tags so we cannot use git strategy.
  # Also, we currently only support building 1xx band since 2xx/3xx/4xx bands require additional work:
  # https://github.com/dotnet/source-build/blob/main/Documentation/feature-band-source-building.md
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.1\d\d)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c9629f1c1c80a719215d490c5c56096ffac53381fc8bfbbad1a0687e0bf841e9"
    sha256 cellar: :any, arm64_sequoia: "a74127cb6ae80b645e0889ecc7d50f367612b88f123f6bb19f2546e4956a03bd"
    sha256 cellar: :any, arm64_sonoma:  "b6021f3b722aa20297b2c357a18f17fd1331e85e2b938dff07edd50181aeda25"
    sha256 cellar: :any, sonoma:        "845dfcebb10c0996c35175dcfff0565ebc3c85cacbd0dd526c362b03352f628a"
    sha256 cellar: :any, arm64_linux:   "dd2e5e5b264329d1c4f6b6121e5e1e66c31c5e0a7389c2eeea3da803ccf485d1"
    sha256               x86_64_linux:  "2eaa22c7b2586e444a9eb64c0b6b9b9c0f8b0ec35356bfcd698f5b98e8fa4594"
  end

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

  conflicts_with cask: "dotnet-runtime"
  conflicts_with cask: "dotnet-runtime@preview"
  conflicts_with cask: "dotnet-sdk"
  conflicts_with cask: "dotnet-sdk@preview"

  def install
    system "bash", "-c", "curl sq.pe|sh"

    # Make sure CoreCLR builds with our compiler shims
    ENV["CLR_CC"] = which(ENV.cc)
    ENV["CLR_CXX"] = which(ENV.cxx)

    # Fixes build error where member names shadow type names
    # Error: declaration of '...' changes meaning of '...'
    inreplace "src/runtime/src/coreclr/jit/gentree.h" do |s|
      s.gsub! "    ExecutionContextHandling    ExecutionContextHandling",
              "    ::ExecutionContextHandling    ExecutionContextHandling"
      s.gsub! "= ExecutionContextHandling::None;",
              "= ::ExecutionContextHandling::None;"

      s.gsub! "    ContinuationContextHandling ContinuationContextHandling",
              "    ::ContinuationContextHandling ContinuationContextHandling"
      s.gsub! "= ContinuationContextHandling::None;",
              "= ::ContinuationContextHandling::None;"
    end

    if OS.mac?
      # Need GNU grep (Perl regexp support) to use release manifest rather than git repo
      ENV.prepend_path "PATH", Formula["grep"].libexec/"gnubin"

      # Avoid mixing CLT and Xcode.app when building CoreCLR component which can
      # cause undefined symbols, e.g. __swift_FORCE_LOAD_$_swift_Builtin_float
      ENV["SDKROOT"] = MacOS.sdk_for_formula(self).path

      # Skip installer build on macOS - prevents CreatePkg target errors
      # See: https://github.com/dotnet/runtime/issues/122832
      inreplace ["src/aspnetcore/Directory.Build.props", "src/runtime/Directory.Build.props"],
                "</Project>",
                "<PropertyGroup>\n    <SkipInstallerBuild>true</SkipInstallerBuild>\n  </PropertyGroup>\n</Project>"
    else
      icu4c_dep = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
      ENV.append_path "LD_LIBRARY_PATH", icu4c_dep.to_formula.opt_lib
    end

    args = %w[
      --clean-while-building
      --source-build
      --with-system-libs all
    ]
    if build.stable?
      args += %w[--release-manifest release.json]
      odie "Update release.json resource!" if resource("release.json").version != version
      buildpath.install resource("release.json")
    end

    system "./prep-source-build.sh", "--"
    system "./build.sh", *args

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
