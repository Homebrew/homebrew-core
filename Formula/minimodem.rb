class Minimodem < Formula
  desc "General-purpose software audio FSK modem"
  homepage "http://www.whence.com/minimodem/"
  url "http://www.whence.com/minimodem/minimodem-0.24.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/minimodem/minimodem_0.24.orig.tar.gz"
  sha256 "f8cca4db8e3f284d67f843054d6bb4d88a3db5e77b26192410e41e9a06f4378e"

  bottle do
    cellar :any
    sha256 "4c89fe35fbc5478c20d1db50f023c7c89467b7fbd17bd77810a6e8ff63e4b945" => :mojave
    sha256 "091170cbfa058de152f2f1af5f2436963297c01e323e80fdfcd5bcf6d8c9cabd" => :high_sierra
    sha256 "224fc001ea92a1df8133680c6eb9b6d659912d5e8ce84e8c12509a671538d8ae" => :sierra
    sha256 "1539133df2fe9f85e8dcdf56e2a62d5ae116861e6dbc3b02e45680fbf8a467a9" => :el_capitan
    sha256 "ac39bf2ca304ce0f513a037193aca0850cf3cafddf17cd40a2ac047e5f051db7" => :yosemite
    sha256 "bbd84e83ce1e3a2f7f257d5c8b5fafd998187aeeb78b5d98eeb4ca97fc90d00e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "libsndfile"
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
