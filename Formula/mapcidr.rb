class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/v1.0.3.tar.gz"
  sha256 "57684ee0ad18c4e96a2b6c3da88d8b22a2413253ff157b20c595a0a5f554136d"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "949ac609bc7c3438fad8c39b5bff55336726ef81f22f2e6180904977b11c8f0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39c598154d9522c7bfb31672c4faa912a614d1f197cfa0f0df4a5e7c6f95e006"
    sha256 cellar: :any_skip_relocation, monterey:       "14ee641d639f00e954f29dd1300ebde6c31d6df3b7ac49edf3d700929e672848"
    sha256 cellar: :any_skip_relocation, big_sur:        "be7526c08024ecd1d7ec801abd68de9788b2aa4e9ee2e28a12b5710a60a665c3"
    sha256 cellar: :any_skip_relocation, catalina:       "b885c1dae308a924909ae6a40dcd0378142a86069fcbebec33aaf948b753c2e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed84a83b3d297e7679ab9e247e4904181d28b96b8a58b242f932e0c2350992f0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/mapcidr"
  end

  test do
    expected = "192.168.0.0/18\n192.168.64.0/18\n192.168.128.0/18\n192.168.192.0/18\n"
    output = shell_output("#{bin}/mapcidr -cidr 192.168.1.0/16 -sbh 16384 -silent")
    assert_equal expected, output
  end
end
