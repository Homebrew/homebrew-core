class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "http://graphite.sil.org"
  url "https://github.com/silnrsi/graphite/releases/download/1.3.10/graphite2-1.3.10.tgz"
  sha256 "90fde3b2f9ea95d68ffb19278d07d9b8a7efa5ba0e413bebcea802ce05cda1ae"
  head "https://github.com/silnrsi/graphite.git"

  bottle do
    cellar :any
    sha256 "dfca853f8ad5b826227e2f5d6dbb0de177e4e4226d255b856c3501fda09dbf3d" => :sierra
    sha256 "271745aed3d0fdf8ded9037df02a404fa883060e7bc46c7c2b9d6f8cbb1022b4" => :el_capitan
    sha256 "325c033b1fd5934ef36735ec2b5ca4c33dd832e80ac09d1164b429e86d71114f" => :yosemite
  end

  depends_on "cmake" => :build

  resource "testfont" do
    url "https://scripts.sil.org/pub/woff/fonts/Simple-Graphite-Font.ttf"
    sha256 "7e573896bbb40088b3a8490f83d6828fb0fd0920ac4ccdfdd7edb804e852186a"
  end

  def install
    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    resource("testfont").stage do
      shape = shell_output("#{bin}/gr2fonttest Simple-Graphite-Font.ttf 'abcde'")
      assert_match /67.*36.*37.*38.*71/m, shape
    end
  end
end
