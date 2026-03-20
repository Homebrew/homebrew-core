class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  license "MIT"
  version_scheme 1
  head "https://github.com/dotnet/dotnet.git", branch: "main"

  stable do
    # Source-build tag announced at https://github.com/dotnet/source-build/discussions
    url "https://github.com/dotnet/dotnet/archive/refs/tags/v10.0.105.tar.gz"
    sha256 "c634e849db52424b75c82c010116cb8290bc952431b7ccf6078ed7365d57b90e"

    resource "release.json" do
      url "https://github.com/dotnet/dotnet/releases/download/v10.0.105/release.json"
      sha256 "e8f1ccc6f7f1e2f5b2265bcab5a5351535288c9c5261ac7c677e865a6a547dcd"

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
    sha256 cellar: :any,                 arm64_tahoe:   "7a473a10c5f4b75cc5c4ded89263cfeb5c9d50e2520935cce75be400f5b14ffa"
    sha256 cellar: :any,                 arm64_sequoia: "3dc28e3e729add4029a3b0b2b302c449a4321bdd1e189091d1d5cd2ee912420a"
    sha256 cellar: :any,                 arm64_sonoma:  "410db18a7f83def7d657cd67f5e8e79e5d54d3f55226bf2ed44196d8fa55a710"
    sha256 cellar: :any,                 sonoma:        "28ea46ab7b6fffced27292dc10790063a2d426c1792170a863fdc0704127044e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e72ff8fed4f6b10b62f78dd62fc996d3d5c3c1dde9b2c3f6eadf5b09f1c0a9a6"
    sha256                               x86_64_linux:  "bdab4c1a8a2cd86ac784ba1d95d18ff9b9bc796c159f86655b6929e9befabee2"
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
