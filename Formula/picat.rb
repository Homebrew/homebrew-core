class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat28_5_src.tar.gz"
  version "2.8#5"
  sha256 "3e88f2d2afdda77754e3dde2da50b7a6ee738c98766b03fb9e25cd006ee13652"

  bottle do
    cellar :any_skip_relocation
    sha256 "1285af233ca1e57d8264d4e0b2b594e7b65a2c44573d3832803e9548cc06baf7" => :catalina
    sha256 "684e67382c19215ba651e39d8bc082b1a41e0095b97ffe6a952d9ff359f750b9" => :mojave
    sha256 "589561d27745924b0af772a47f547c0441fa8a3cf45c170a85c3b6c7809508ca" => :high_sierra
  end

  def install
    system "make", "-C", "emu", "-f", "Makefile.mac64"
    bin.install "emu/picat" => "picat"
    prefix.install "lib" => "pi_lib"
    doc.install Dir["doc/*"]
    pkgshare.install "exs"
  end

  test do
    output = shell_output("#{bin}/picat #{pkgshare}/exs/euler/p1.pi").chomp
    assert_equal "Sum of all the multiples of 3 or 5 below 1000 is 233168", output
  end
end
