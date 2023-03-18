class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/v1.1.1.tar.gz"
  sha256 "12a7dee0dd2c02eb339d308e7144bb12610e515e5ae8ae720bf2ce9ed7ed9b78"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "457a25190372d0f9033da92a7791bb4c39fb53e3512bed3d3a382423f5a28532"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b47f008b1e0f19e92780dd037bc45374d29cce45cf872474030e950f0e123a9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f14761713af0e4a469745e475b4c2ff6c72b6f62b95fd80bc77015e28e856cd3"
    sha256 cellar: :any_skip_relocation, ventura:        "dfd4f5ed3d8466f9f764ce2139de7ebd981897f61b21e712dfcc3e3775bcb907"
    sha256 cellar: :any_skip_relocation, monterey:       "1d66678a31f51b6d4c5e5235d53c9ca049476d5034e9cd0beb07a9ecdbc1b26b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c797cf040f588d1124942a6675a0d1528edb63bb38740f9f5d56d8a0526fda1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81df54bfbc2a3fe180d1942f1d226d409b1e9b60cadc60bfced81aad54935c2a"
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
