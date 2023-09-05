class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/v1.1.2.tar.gz"
  sha256 "52dcf9181d361c444823e64e1a89a9da0e4a3bd8fdf26e0d8a803589fa935289"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9af6814440de27f54ab5bd2a0096db21d1fee0e464bff18a53132b1012eaf13a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9af6814440de27f54ab5bd2a0096db21d1fee0e464bff18a53132b1012eaf13a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9af6814440de27f54ab5bd2a0096db21d1fee0e464bff18a53132b1012eaf13a"
    sha256 cellar: :any_skip_relocation, ventura:        "60bf35eb1d5d30bdf735b803cd5e4bce19f0210d35702f7e28f4cbbd210e1da8"
    sha256 cellar: :any_skip_relocation, monterey:       "60bf35eb1d5d30bdf735b803cd5e4bce19f0210d35702f7e28f4cbbd210e1da8"
    sha256 cellar: :any_skip_relocation, big_sur:        "60bf35eb1d5d30bdf735b803cd5e4bce19f0210d35702f7e28f4cbbd210e1da8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2160cd85b023720848f0a09f34cb62736e166738e10aa0e8afa3aac683104e5"
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
