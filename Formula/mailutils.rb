class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.15.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.15.tar.gz"
  sha256 "91c221eb989e576ca78df05f69bf900dd029da222efb631cb86c6895a2b5a0dd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "9666c235384f4a7e5d69b029aef43c3488b4a2f9620e0e2210edbcdb58ddaa50"
    sha256 arm64_big_sur:  "c6c62e8822632d12e622fc3799cf7cae18abfe164661a68594eb42e9d584ee86"
    sha256 monterey:       "c0755eedc6e67dfa783217e318ea11ffae75d3043f30b5ace0ff12d22936163d"
    sha256 big_sur:        "4981b3d9a9991ed02e682d30a9ab095213f33da632b27c1120fcad8076333eab"
    sha256 catalina:       "19cc355b4e7653dbfb7a86da58b33d718c669b4a5c8cb03e4b33e46980854636"
    sha256 x86_64_linux:   "b9e2e2a236860cf7fdca1faea38ef945f257ccaadbba27b6af8bb3b15f2c8592"
  end

  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "libtool"
  depends_on "readline"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

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
