class CyclonedxCli < Formula
  desc "Tool for analysis and manipulation of CycloneDX SBOMs"
  homepage "https://cyclonedx.org/"
  url "https://github.com/CycloneDX/cyclonedx-cli/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "9ba4bcb4c315b28fbf5e461511ff94c5b8088a4696b018368694bd235341d3cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0daaaa9a506c7c8970c278ef62670c8e6b7b7116d9793cdaff95a403fcfac89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38eb945d4f7aaaf592775b77bb3028c3deaab1ffc0c764d0a896cf313c5ac67d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f642bb4ad9f9a4a5cdefdd4bc071dbf9883e06a9b302323876b5e419ec3d1e17"
    sha256 cellar: :any_skip_relocation, sonoma:        "233cae284ad5950e23da9ed3751a682790e591dd0b60c07063b23a14abf17fe1"
    sha256 cellar: :any,                 arm64_linux:   "6034df8e976469768fbacaab95eaff55c6c729e423d9d42eb26e30d28a20367f"
    sha256 cellar: :any,                 x86_64_linux:  "f812684f055c3cd6a2a38950ec57ed8735ee9c662b2dd435e0417bbcba2613ff"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
      -p:DebugSymbols=false
      -p:DebugType=None
      -p:PublishSingleFile=true
      -p:PublishTrimmed=false
      -p:Version=#{version}
    ]
    system "dotnet", "publish", "src/cyclonedx/cyclonedx.csproj", *args
    bin.install_symlink libexec/"cyclonedx"
  end

  test do
    resource "document.spdx.json" do
      url "https://raw.githubusercontent.com/CycloneDX/cyclonedx-cli/refs/tags/v0.32.0/tests/cyclonedx.tests/Resources/document.spdx.json"
      sha256 "6fed40c4b4774821c2a9002b3ad44c1234987ff5d7780345ed29b01e942b8142"
    end

    testpath.install resource("document.spdx.json")
    system bin/"cyclonedx", "convert", "--input-file=document.spdx.json", "--output-file=bom.cdx.json"
    system bin/"cyclonedx", "validate", "--input-file=bom.cdx.json"

    assert_equal version.to_s, shell_output("#{bin}/cyclonedx --version").strip
  end
end
