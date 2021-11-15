class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  url "https://github.com/dotnet/source-build.git",
      tag:      "v5.0.207-SDK",
      revision: "52296950a9e8d1b34a2e0e10e4b8bb06daba2dcc"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)-SDK$/i)
  end

  bottle do
    sha256 cellar: :any,                 big_sur:      "dd058f1a46a84ee8cfbdf5450a5248ca1b5af91ae018efd5f96b0b760a4cc84f"
    sha256 cellar: :any,                 catalina:     "a9c2b8e900351d1cb074100a60de404f033436032c1116c6094351446253e777"
    sha256 cellar: :any,                 mojave:       "b7a7a743c0b409569cc5f139ada574e0b32f331b2950252a5afb2809123514d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dd46b0305e565a6a6da6768a2d8d15a4e080cae9b9f29c4e9595067ed068d8c9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on arch: :x86_64
  depends_on "curl"
  depends_on "icu4c"
  depends_on "openssl@1.1"

  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_linux do
    depends_on "llvm" => [:build, :test]
    depends_on "libunwind"
    depends_on "lttng-ust"
  end

  fails_with :gcc

  def install
    ENV.append_path "LD_LIBRARY_PATH", Formula["icu4c"].opt_lib if OS.linux?

    # Arguments needed to not artificially time-limit downloads from Azure.
    # See the following GitHub issue comment for details:
    # https://github.com/dotnet/source-build/issues/1596#issuecomment-670995776
    system "./build.sh", "/p:DownloadSourceBuildReferencePackagesTimeoutSeconds=N/A",
                         "/p:DownloadSourceBuiltArtifactsTimeoutSeconds=N/A"

    libexec.mkpath
    tarball = Dir["artifacts/*/Release/dotnet-sdk-#{version}-*.tar.gz"].first
    system "tar", "-xzf", tarball, "--directory", libexec
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
