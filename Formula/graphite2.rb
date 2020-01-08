class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "https://graphite.sil.org/"
  url "https://github.com/silnrsi/graphite/releases/download/1.3.13/graphite2-1.3.13.tgz"
  sha256 "dd63e169b0d3cf954b397c122551ab9343e0696fb2045e1b326db0202d875f06"
  head "https://github.com/silnrsi/graphite.git"

  bottle do
    cellar :any
    sha256 "988b7fb96aeb784dfd553a0203c48181631a99bb22aea4da31c014c66c6fe060" => :catalina
    sha256 "d1f97782079841862d16e256fa735fff3fba05b431d2b511c44e259c4ede830b" => :mojave
    sha256 "b85d96057af2671346e6f3ae5d7c27e47774fa0c9ec6c401d8ebf3f290f8274d" => :high_sierra
    sha256 "3aa5eeba93470994d028afa0180f9122f3185a2e72179698ce781561e9287af6" => :sierra
  end

  depends_on "cmake" => :build

  resource "testfont" do
    url "https://scripts.sil.org/pub/woff/fonts/Simple-Graphite-Font.ttf"
    sha256 "7e573896bbb40088b3a8490f83d6828fb0fd0920ac4ccdfdd7edb804e852186a"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    resource("testfont").stage do
      shape = shell_output("#{bin}/gr2fonttest Simple-Graphite-Font.ttf 'abcde'")
      assert_match /67.*36.*37.*38.*71/m, shape
    end
  end
end
