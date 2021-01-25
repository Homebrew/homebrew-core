class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "https://sourceforge.net/projects/faac/"
  url "https://downloads.sourceforge.net/project/faac/faac-src/faac-1.29/faac-1.29.9.2.tar.gz"
  sha256 "d45f209d837c49dae6deebcdd87b8cc3b04ea290880358faecf5e7737740c771"

  livecheck do
    url :stable
    regex(%r{url=.*?/faac[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "15eb46101d9d0e50c8b87977f8b87dceafa4e9c0c165a2ff9a41fd94afe73b66" => :big_sur
    sha256 "6438d37d23478f1ece8c5370b62298d756b331de7bda2780ee64ef8446da7f19" => :arm64_big_sur
    sha256 "5687b72d43334c52e8b4daa4eda547d9541812807bf7b89d63be9a1e487ae78f" => :catalina
    sha256 "27f7a5da217b0cb75caa8fd33bd19dc5a1f741b290f30b0c5491bc3a84aed38c" => :mojave
    sha256 "73e02bf58df497bf2c35e8374c000fc8ed989c167b559b9efe2f5874687fe849" => :high_sierra
    sha256 "9ed007e0aaeaddb47d284a81f2783c6ddcf9af86e0ed1da1a9b94aa84dfd1a34" => :sierra
    sha256 "4dd46a72ce3a5355efa42038df34b9bfda51ae6265be89eb09f1b8957ef3653d" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert_predicate testpath/"test.m4a", :exist?
  end
end
