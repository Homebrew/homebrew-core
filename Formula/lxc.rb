class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-5.11.tar.gz"
  sha256 "eb3e82d675a69c72dd2ed2dfee5d5fe2b88686e3f62769adf2655664889e81ed"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16819b6133b41ea42f021645d72506eb7b81e503af7acd05f14776f76daf8823"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a55b061bc45573f3a244cd2966c7267e9cd94168affbe8a567ea35725cad70b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbde362bbe925f88e92c818a514b3e1c956d5e8d496cb644253ccd289050c454"
    sha256 cellar: :any_skip_relocation, ventura:        "2c0dea7d810c48a6e4d2ba3045f70068eadd0a5fbfa29040c0b02b4c99d93b28"
    sha256 cellar: :any_skip_relocation, monterey:       "7e6f9bb0dca1e2b4cf341fe540477f03e33e4cb77ff800094c68c9f61f360567"
    sha256 cellar: :any_skip_relocation, big_sur:        "86f4e37d62264bebac8d3e672f8c26938a1fb92d41a771489f22333f465c14ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddfed4d4a37ea406c9085261e48e1ea49ab410ada274d7dc3914fd657afa92f4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]
  end
end
