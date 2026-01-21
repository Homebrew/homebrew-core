class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  license "MIT"
  version_scheme 1
  head "https://github.com/dotnet/dotnet.git", branch: "main"

  stable do
    # Source-build tag announced at https://github.com/dotnet/source-build/discussions
    url "https://github.com/dotnet/dotnet/archive/refs/tags/v10.0.102-sb1.tar.gz"
    version "10.0.102"
    sha256 "cc544f357e3674f3f4d170c82f781f6f9406760e8badbe1fbcaf04657e1554d4"

    resource "release.json" do
      url "https://github.com/dotnet/dotnet/releases/download/v10.0.102-sb1/release.json"
      sha256 "f22c317a69e38fbd5f1b0cf482065c8cc40dddedb4c3dc7f659c07b3603c46ed"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a9deaed142a3b459cd2ef0bdcef80e35ebc969e23829bd67cf27d8d70f5f4847"
    sha256 cellar: :any,                 arm64_sequoia: "f493923c039918e9ffb6df9a0aecc99d6dc41a2d739ebb4d0ff0df5e6c438dc4"
    sha256 cellar: :any,                 arm64_sonoma:  "0bb256b07f545fae407a2b113ab836bc39cc26184d9ce56176e5f27de94ec7ff"
    sha256 cellar: :any,                 sonoma:        "a367371bb8c135d7383fa3b9c57052b4faaf18a336e1125bf2d8d5afb9521406"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3df0c663104332af2706dab8a7806f58937be0426e401e31efe8e9918093c85"
    sha256                               x86_64_linux:  "8e8217be0316b539ecf9e345e3edd2c58762af31deaee9ff4e992f4292232f06"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "brotli"
  depends_on "icu4c@78"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
    depends_on "bash" => :build
    depends_on "grep" => :build # grep: invalid option -- P
  end

  on_linux do
    depends_on "libunwind"
    depends_on "lttng-ust"

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
      --branding release
      --clean-while-building
      --source-build
      --with-system-libs all
    ]
    if build.stable?
      args += ["--release-manifest", "release.json"]
      odie "Update release.json resource!" if resource("release.json").version != version
      buildpath.install resource("release.json")
    end

    system "./prep-source-build.sh"
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
