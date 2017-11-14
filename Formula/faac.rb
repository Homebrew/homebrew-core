class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "http://www.audiocoding.com/faac.html"
  url "https://downloads.sourceforge.net/project/faac/faac-src/faac-1.29/faac-1.29.9.2.tar.gz"
  sha256 "d45f209d837c49dae6deebcdd87b8cc3b04ea290880358faecf5e7737740c771"

  bottle do
    cellar :any
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
