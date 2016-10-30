class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "http://graphite.sil.org"
  url "https://github.com/silnrsi/graphite/archive/1.3.8.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/graphite2/graphite2_1.3.8.orig.tar.gz"
  sha256 "954f3dc88f4cf02d892697f4fb7e5bb5a515da81eb26e63f7d1a046459ed7842"
  head "https://github.com/silnrsi/graphite.git"

  bottle do
    cellar :any
    sha256 "8d4e0b45193cf7188da3a051f54a650ac79542b8943b8bd83fad5d413a358183" => :sierra
    sha256 "370edc1fe934114152aff3075bbaadc342044239faf9c5893677bbf6c05194ae" => :el_capitan
    sha256 "47d2137c843fe5bbc7f0351c8f3b4410607862329d841dac33aa9fe1867d2481" => :yosemite
    sha256 "9213295b7665ee17f45d3c76fca8a20fbf51c616e3e16d680379f1e5732a0c6d" => :mavericks
  end

  option :universal

  depends_on "cmake" => :build

  resource "testfont" do
    url "https://scripts.sil.org/pub/woff/fonts/Simple-Graphite-Font.ttf"
    sha256 "7e573896bbb40088b3a8490f83d6828fb0fd0920ac4ccdfdd7edb804e852186a"
  end

  def install
    ENV.universal_binary if build.universal?

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
