class OpenscaCli < Formula
  desc "OpenSCA is a supply-chain security tool for security researchers and developers"
  homepage "https://opensca.xmirror.cn"
  url "https://github.com/XmirrorSecurity/OpenSCA-cli/archive/refs/tags/v3.0.10.tar.gz"
  sha256 "9aa71e08e252e5a817e35d02c10f33e892e18005cf9f81080ef19a2455bdc696"
  license "Apache-2.0"
  head "https://github.com/XmirrorSecurity/OpenSCA-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f722830c0675e3acc563072214f4d2b616eef591a7541c135e6eb06f417ebf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfe931d6004e3b34851a74370340a5f3c2a34e04508ca1cd88f7d4bd65e31eb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc3a3bb01d6806ad313f7325b0391dc29b6c09b20b47b01a4d6191a5b2f5a1ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7c7918457e484925465509ecb78c2682002d424299b4bb8a7882407959e61ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2a276c9936bfca76d2310ac371e9ddecd589e499985703441e561a7696c2523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e496d5b0b324d5d3777a2fdfb58374c9352ec55994511da9adaa30e80d5d1d3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.version=#{version}'"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"opensca-cli", "-path", testpath
    assert_path_exists testpath/"opensca.log"
    assert_match version.to_s, shell_output("#{bin}/opensca-cli -version")
  end
end
