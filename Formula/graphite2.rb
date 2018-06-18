class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "http://graphite.sil.org"
  url "https://github.com/silnrsi/graphite/releases/download/1.3.11/graphite2-1.3.11.tgz"
  sha256 "bab92ed1844d6538e7e5bda76f6ac9aaf633e38b683983b942c78c8ce063ad7c"
  head "https://github.com/silnrsi/graphite.git"

  bottle do
    cellar :any
    sha256 "29a315e9848bc5e5c4b1ccdae1463593a4bc9f57a6137c68c7db73f1ea06b234" => :high_sierra
    sha256 "bbcbe84fb04cb25ffb7f481720ce4dc238844a087739075f7d689beab56f7b2c" => :sierra
    sha256 "a2a85fc1b473c1725f8bac8fedd1ae7c8deac5b78708414381159daa83b5e9c1" => :el_capitan
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
