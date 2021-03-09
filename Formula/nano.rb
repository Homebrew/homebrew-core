class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v5/nano-5.6.1.tar.xz"
  sha256 "760d7059e0881ca0ee7e2a33b09d999ec456ff7204df86bee58eb6f523ee8b09"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "5034b239388afcbf85b2cf42c542c8347c748c66eddbf6fb1f83c29ef19ba898"
    sha256 big_sur:       "f6c6aa9cfc1f0e67695e2ef1b24d8b191291b9e551a8a86583d5a5ceb249ce54"
    sha256 catalina:      "ecbab1457df82503febdb73caaf7aca750c713f2f55803cb8f31ef89961a398e"
    sha256 mojave:        "88e884887bd9829c45afa8426cefc247f0fd57faa4985d296a8fc289bf39325e"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8"
    system "make", "install"
    doc.install "doc/sample.nanorc"
  end

  test do
    system "#{bin}/nano", "--version"
  end
end
