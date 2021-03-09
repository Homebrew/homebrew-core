class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  url "https://github.com/dotnet/source-build.git",
      tag:      "v5.0.103-SDK",
      revision: "ccff33e9e87656ab8349dba6779363b15d53d56a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)-SDK$/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "5c84f114b503fb06056fbb92ff9ef62a577200e24b9db5d38805527010d301e3"
    sha256 cellar: :any, catalina: "dccd1ebb58287b14a845f9c6cde98f449bfd3bbc94ea532f03917e486efb1e3f"
    sha256 cellar: :any, mojave:   "f9bd9adff1ec683b00f63d6349bd50a22a8cf51fed9c7dd0c5a55b9aa6ddfe62"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on "curl"
  depends_on "icu4c"
  depends_on "openssl@1.1"

  def install
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
