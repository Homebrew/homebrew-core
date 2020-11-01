class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  url "https://github.com/dotnet/source-build.git",
      tag:      "v3.1.109-SDK",
      revision: "a5bf06c9d45144d6e152f5e53155e41839aa4a55"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)-SDK$/i)
  end

  bottle do
    cellar :any
    sha256 "f6c4d1db106a901e28fb32cbd7d5eadf09ad4b934c5329acafc1d126ce0c4300" => :catalina
    sha256 "39a01a9e7855df54640d1b234001f09bd36dacc95e62b7ff22edb3fb1c9cab15" => :mojave
    sha256 "672944a955d164420b9b1977a4ab457bdc0d6fbd03ef0cb05aad433108bf72c7" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on "curl"
  depends_on "icu4c"
  depends_on "openssl"

  # Patch of https://github.com/dotnet/source-build/pull/1789 which will be
  # released with tag 3.1.110 in November 2020.
  resource "0005-Fix-bad-configure-tests.patch" do
    url "https://raw.githubusercontent.com/dotnet/source-build/17c6409189ed29f0fac2e8f4b1c30d882e6756b5/patches/coreclr/0005-Fix-bad-configure-tests.patch"
    sha256 "57b83f9445d59137bdcc31c2a64d413bae23e80dc18f6fbcd8ceaac1d8b6754b"
  end

  def install
    resource("0005-Fix-bad-configure-tests.patch").stage buildpath/"patches/coreclr"

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

  test do
    target_framework = "netcoreapp3.1"
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
