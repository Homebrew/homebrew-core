class Nrg2iso < Formula
  desc "Extract ISO9660 data from Nero nrg files"
  homepage "http://gregory.kokanosky.free.fr/v4/linux/nrg2iso.en.html"
  url "http://gregory.kokanosky.free.fr/v4/linux/nrg2iso-0.4.tar.gz"
  sha256 "25049d864680ec12bbe31b20597ce8c1ba3a4fe7a7f11e25742b83e2fda94aa3"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b1896503c9c1944672f043adebe206ec236d51253f4c2057fcb83694477434b"
    sha256 cellar: :any_skip_relocation, big_sur:       "de13076ac7730d2b664fbdfe4128b17f0c61fc458c9bfd82b5fbf638ec526702"
    sha256 cellar: :any_skip_relocation, catalina:      "709c3f50eaf96b520116f8990fdab7cd52e271b3025d52724ba04aa50b025f17"
    sha256 cellar: :any_skip_relocation, mojave:        "6ff39712b0f4c8ba707eb1850ced8e9e0f14d3dc615cb9fb5a16456f0f69d680"
    sha256 cellar: :any_skip_relocation, high_sierra:   "7fcd88c9587e77ec07210ace97b4432197545ea4d70ff547b1b44977aef8eb8a"
    sha256 cellar: :any_skip_relocation, sierra:        "01177e7bc064b062c454caad61c24b80deb20768ab2d880c77ba20708ac6e709"
    sha256 cellar: :any_skip_relocation, el_capitan:    "fed88dfb217cc0b5fa0a4f7a7aec40342314998624e084921e1b5cc02d08d27d"
    sha256 cellar: :any_skip_relocation, yosemite:      "18949f41b9ba386c996a49541875d3320184b88dccb04136846f32b3d681e647"
  end

  def install
    system "make"
    bin.install "nrg2iso"
  end

  test do
    assert_equal "nrg2iso v#{version}",
      shell_output("#{bin}/nrg2iso --version").chomp
  end
end
