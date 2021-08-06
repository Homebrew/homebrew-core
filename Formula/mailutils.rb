class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.13.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.13.tar.gz"
  sha256 "41234389452805e5a47cec4fd57c61feee0cdaa6de94d0ded0cd33e778f58de2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "4f56ee5963a199cbf16e7418f8eb656a1396cee297de7dc708ff3f37f1733a69"
    sha256 big_sur:       "e341518e551aed3c4ffb4b3fa72ea6725834fdc6fab187218b31eaf11b7e3e47"
    sha256 catalina:      "710553bf2b8f3946adf42cbe918df0d6bc83fe93d9a6134a863e95e73c1b009b"
    sha256 mojave:        "fdc180f3df9812370849499c0946d548910a97c5c2a1875f6796916a5b341d2a"
    sha256 x86_64_linux:  "05e0cc9e36bc232b3ff85294da1e5a3f8d3a651987a6daad75f63996b3d121ee"
  end

  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "libtool"
  depends_on "readline"

  def install
    system "./configure", "--disable-mh",
                          "--prefix=#{prefix}",
                          "--without-fribidi",
                          "--without-gdbm",
                          "--without-guile",
                          "--without-tokyocabinet"
    system "make", "PYTHON_LIBS=-undefined dynamic_lookup", "install"
  end

  test do
    system "#{bin}/movemail", "--version"
  end
end
