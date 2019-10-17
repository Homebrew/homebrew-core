class Nrg2iso < Formula
  desc "Extract ISO9660 data from Nero nrg files"
  homepage "http://gregory.kokanosky.free.fr/v4/linux/nrg2iso.en.html"
  url "http://gregory.kokanosky.free.fr/v4/linux/nrg2iso-0.4.tar.gz"
  sha256 "25049d864680ec12bbe31b20597ce8c1ba3a4fe7a7f11e25742b83e2fda94aa3"

  bottle do
    cellar :any_skip_relocation
    sha256 "709c3f50eaf96b520116f8990fdab7cd52e271b3025d52724ba04aa50b025f17" => :catalina
    sha256 "6ff39712b0f4c8ba707eb1850ced8e9e0f14d3dc615cb9fb5a16456f0f69d680" => :mojave
    sha256 "7fcd88c9587e77ec07210ace97b4432197545ea4d70ff547b1b44977aef8eb8a" => :high_sierra
    sha256 "01177e7bc064b062c454caad61c24b80deb20768ab2d880c77ba20708ac6e709" => :sierra
    sha256 "fed88dfb217cc0b5fa0a4f7a7aec40342314998624e084921e1b5cc02d08d27d" => :el_capitan
    sha256 "18949f41b9ba386c996a49541875d3320184b88dccb04136846f32b3d681e647" => :yosemite
    sha256 "a46624bc9fc5f7883e923920dbc96aef720e5bb37b4ac71a281d101b96decee6" => :mavericks
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
