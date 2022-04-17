class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.15.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.15.tar.gz"
  sha256 "91c221eb989e576ca78df05f69bf900dd029da222efb631cb86c6895a2b5a0dd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "3676d1f4cab1d27987c50cccf312ec05e3b4065a8f7c5e11504299c16e5f2b70"
    sha256 arm64_big_sur:  "31d3f0434129754e988973fe9b1ee7363ac6611bde6bd21f5fde5cbc212594f2"
    sha256 monterey:       "c778c7f6f8dcace8ce29c24789278009598e02dfeef40e165f1c183d58982c19"
    sha256 big_sur:        "3a0f53115531b1dafdc1d7a69b2852f5e27be1026bf5b80ea21e1a6503542c42"
    sha256 catalina:       "0affdc7933c5c1efd50fbca3e8a9e6f3e8ce75bff2f5980db738cdf4c3baf82e"
    sha256 x86_64_linux:   "3b69c1a4b624b1813506e3351abf4ae5ae633718fbc014cf152d474b26ebcddd"
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
