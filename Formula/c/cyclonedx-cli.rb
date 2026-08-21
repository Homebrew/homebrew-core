class CyclonedxCli < Formula
  desc "Tool for analysis and manipulation of CycloneDX SBOMs"
  homepage "https://cyclonedx.org/"
  url "https://github.com/CycloneDX/cyclonedx-cli/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "01574e2e7d1cfe88ed50bbe7e87663af45a6b261ba11518a6c8eb34f809e1309"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88789392e58285e6a27ab278bef389be13d591e5bdca3c2682fa67eebe4c7122"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c21eabe200a5b8ada0f28d3b3cd28d2699341e9b1ffbe8b1d1246d3a569af37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c443efde24a363ce5892f49e00a53d94a0e9ae1a6cd3dc37b093088501e2df2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cecb41f57fa5bbe1f27eb3939517a4907e4cec7a22f16cf8486eceba2e04e9e"
    sha256 cellar: :any,                 arm64_linux:   "d50b34cd4e8fbdfb73263e7b75368de51d95f256e3c1b76229434ca0759f8a87"
    sha256 cellar: :any,                 x86_64_linux:  "7fbd6f25855a93759926a25257efffc1293e6a6b9247303f98f4b5bc53338d57"
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
