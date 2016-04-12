class Minimodem < Formula
  desc "General-purpose software audio FSK modem"
  homepage "http://www.whence.com/minimodem/"
  url "http://www.whence.com/minimodem/minimodem-0.23.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/minimodem/minimodem_0.23.orig.tar.gz"
  sha256 "aab1eacdb0567cf743afa20a54842f88ad3c5399878315abbb67692365204323"

  bottle do
    cellar :any
    sha256 "60cbf696ac6cb2fe882643ac19f057bab48552852b40726e3eae88405a9baf4d" => :el_capitan
    sha256 "bc83032841674e84963e355a77fe10fd062ae28f59929219318a68f29af172f6" => :yosemite
    sha256 "5c86b0ec05114f49cc8fb502b8980854be28b9b4e24ca120ae354789b4496aef" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libsndfile"
  depends_on "fftw"
  depends_on "pulseaudio"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-alsa"
    system "make", "install"
  end

  test do
    system "#{bin}/minimodem", "--benchmarks"
  end
end
