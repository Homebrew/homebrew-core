class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.16.0",
      revision: "24a959abf115923910ce18985aa199d85fb602d7"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8797d488886dce292a2b308225ca72358517bf3ded318df8e5c3dcd11f3fb10d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9de7debc5daffdb5f7f2bbd17839673631a51f50bfc27971eee74b418557fbb"
    sha256 cellar: :any_skip_relocation, monterey:       "d9b2c558c1b86d67085c9364e60fcc31ab056eefb7aaa8b9fe856e1fbe68454b"
    sha256 cellar: :any_skip_relocation, big_sur:        "27fa73d034d8f4acf591901fce1f5c9bf3cb7412082a796a3fbd835521b20576"
    sha256 cellar: :any_skip_relocation, catalina:       "997fca5140a5192e3721673d17efb46b048bcdb48d56c394880c8f9cd6b90bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c70a9670512d2fd5ae19ed4a941d181fc2bd8978e476e18744afcc778bf89694"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")
  end

  test do
    assert_match "it does support HTTP/3!", shell_output("#{bin}/quiche-client https://http3.is/")
  end
end
