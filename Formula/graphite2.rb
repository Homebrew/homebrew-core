class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "https://graphite.sil.org/"
  url "https://github.com/silnrsi/graphite/releases/download/1.3.14/graphite2-1.3.14.tgz"
  sha256 "f99d1c13aa5fa296898a181dff9b82fb25f6cc0933dbaa7a475d8109bd54209d"
  head "https://github.com/silnrsi/graphite.git"

  bottle do
    cellar :any
    sha256 "0831f474c920b66bbeab3f93a91fa019b82bfffcdd40e369fdab76372700e980" => :catalina
    sha256 "2f3abb971be03141e9eea54b87c6861d72865bd76fde73ae3161d64c40d51cd9" => :mojave
    sha256 "62e39dce0ae0440ac164edaab6e1351520bc5414ad509fc0b8d5c890500785bd" => :high_sierra
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
