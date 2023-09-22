class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/refs/tags/v1.1.9.tar.gz"
  sha256 "4171988b36924ffeffd70a849d70da2d57205f50179b7b60e36bde4620d4d838"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aacc6259d3c96f34dfdee364ea48557930ccfab96bd79d09ce6f36e881641734"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87aa8262f2a24fae616daed137ea14d7f0ae4a547052db22b05576c1bb87bfb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed75d5cf8bee6817b713c94ee28869f06ec21d680be8d67dc40ab38c26025acd"
    sha256 cellar: :any_skip_relocation, ventura:        "3f5c3666ad37c9af3902ca339045d60f57e8603bdc691da0f6a29f9c4fc3feb6"
    sha256 cellar: :any_skip_relocation, monterey:       "dd8d9dfe78d77df4a487d21b8e09cf0df33e1a7aed0510ada1834d9411ec9c4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "af0b1e5a820c28b05f0d185b7e3fa3ab1469d87addf905f37c862aea5ae7680c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "687f4f11d5e1dfe80968ff49c7704bb92fa47c99b8e42bae366265977b568676"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/mapcidr"
  end

  test do
    expected = "192.168.0.0/18\n192.168.64.0/18\n192.168.128.0/18\n192.168.192.0/18\n"
    output = shell_output("#{bin}/mapcidr -cidr 192.168.1.0/16 -sbh 16384 -silent")
    assert_equal expected, output
  end
end
