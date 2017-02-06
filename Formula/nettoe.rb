class Nettoe < Formula
  desc "Tic Tac Toe-like game for the console"
  homepage "http://nettoe.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nettoe/nettoe/1.5.1/nettoe-1.5.1.tar.gz"
  sha256 "dbc2c08e7e0f7e60236954ee19a165a350ab3e0bcbbe085ecd687f39253881cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "593d6b69194903eda0ed6668c177aef36efcc1bc2bc09763dc21549a8b8803f2" => :el_capitan
    sha256 "48caa53cd7d854aaaf857c46092923a40903720e31cab9187c412efba77f39cb" => :yosemite
    sha256 "bb75d69b61846aa3e399370d2ad6e51ca62f3aa3387e96cef5d4136fec87245d" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /netToe #{version} /, shell_output("#{bin}/nettoe -v")
  end
end
