class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  url "https://github.com/dotnet/source-build.git",
      tag:      "v5.0.205-SDK",
      revision: "42ac4d6d5a1d36cc92c89d0e810fdd2f5ed109c6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)-SDK$/i)
  end

  bottle do
    sha256 cellar: :any,                 big_sur:      "506a88b54fd7728c722c7824055458df93c271d87298b81979257457646dec08"
    sha256 cellar: :any,                 catalina:     "01b623ce85fb1e0bcf78de25193f3778956d62f601b233509999c1d08c1a4c57"
    sha256 cellar: :any,                 mojave:       "6bc5fad76c9f9f3523c3a77d9a03f86ffd25d34c48f54a86b12ae075ab0bca7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "483fc8bab6ee7421f6fe1746c87e3f3db576a8a4a291f22b63fab4556c4863be"
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
    on_linux do
      ENV.append_path "LD_LIBRARY_PATH", Formula["icu4c"].opt_lib
    end

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
