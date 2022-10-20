class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/v1.0.3.tar.gz"
  sha256 "57684ee0ad18c4e96a2b6c3da88d8b22a2413253ff157b20c595a0a5f554136d"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ff28ec5763c3775ce995656912276d872d2d50caf2d25810712972186732ed8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb00622c03508f1a01d7e9591483f92a6dd763726ea6b6a79fca3ad04a2a34e2"
    sha256 cellar: :any_skip_relocation, monterey:       "eb84da9690127dff01884a5b734afff978a0e24b2e6492c34cf5d60adb9e64ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe88f9c586c7e959824039c2de3c79a631907fe66d30f588abc317608877bbb2"
    sha256 cellar: :any_skip_relocation, catalina:       "74c349a227e82a179b4d16278c2238b7a3b9989e69bd1aee28e182d5cbe072fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1979c375301821ff1c14ed9894f180bb8e3a1b671961023e339dddaa113097d8"
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
