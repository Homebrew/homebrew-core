class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  url "https://github.com/dotnet/source-build.git",
      tag:      "v3.1.109-SDK",
      revision: "a5bf06c9d45144d6e152f5e53155e41839aa4a55"
  license "MIT"

  bottle do
    cellar :any
    sha256 "777c2c233711c7c68de632a5ca7c8f08ae8ecc3ee3eb984ce9865add00af9b69" => :catalina
    sha256 "b7c249f4be6c9fa58482b03f3398178131e67db280ee06460988df2a598d3d22" => :mojave
    sha256 "12d970b23c3671c72a9ade43b405f9e8b8779d016c7c846750f6097429158b2e" => :high_sierra
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
