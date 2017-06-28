class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "http://graphite.sil.org"
  url "https://github.com/silnrsi/graphite/releases/download/1.3.10/graphite2-1.3.10.tgz"
  sha256 "90fde3b2f9ea95d68ffb19278d07d9b8a7efa5ba0e413bebcea802ce05cda1ae"
  head "https://github.com/silnrsi/graphite.git"

  bottle do
    cellar :any
    sha256 "8275f72e0fc1aaa42b30b46d2245565571e97d56ebbad3fa94994d235f935eea" => :sierra
    sha256 "3bdeb624f9cc9e71ad554cfa243ff64eac4b3f948a34ed8e1a6d7f9b168b996d" => :el_capitan
    sha256 "e26eb396511e1a327a8173653e65960b14a4499738ef5eb7c54c8d8474fdc011" => :yosemite
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
