class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/v1.0.0.tar.gz"
  sha256 "2e3a0fc4301c6c5ebee75a9c6b7dd2e1c646dc5d67b74f97dc3e2eb187a133de"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb180ee96d7fdcf7c5e4d1d58e8a7d2b8720cebb3227abc724d5327b5c5e3b3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5175d170c9d57cf71c116b094fb7536dd16cfffb3874da6a6a356ce8891f4df2"
    sha256 cellar: :any_skip_relocation, monterey:       "463b942ef6f582a60ac8697646243d9ab29a7fbd445eb7395b36581496de8b61"
    sha256 cellar: :any_skip_relocation, big_sur:        "acc508e1770d68ddac19f52e0f05adebd0af3852b31cbb28defc2e560c71d549"
    sha256 cellar: :any_skip_relocation, catalina:       "8911ce7ddd2e79376040bba13ed3591bf5248b2f5d0659647e6716235cdc28b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "626b6dafd42df64af6d022800eb22ed1c770c3740cd1c61cee2ddd6de61b9e30"
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
