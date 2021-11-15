class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.13.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.13.tar.gz"
  sha256 "41234389452805e5a47cec4fd57c61feee0cdaa6de94d0ded0cd33e778f58de2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "f3d0df511ccf76e83d4ff1b290af40a82b5e8982b45a52fbccd5cfa5c8cacb7a"
    sha256 arm64_big_sur:  "30207f5919cdd31f2fb409d3c1ce2ed7b3f80dd1919c6cfe5fe17b92ae70000a"
    sha256 monterey:       "af82f7aff57b46968e30ef83e5db0a37082d748a1236eddb6abe9a7a0f845f7e"
    sha256 big_sur:        "1182bc30b75d80f84753b5ddf53c74cb7bbeae001286747d402fc8e046c9cfa0"
    sha256 catalina:       "fe4db7c7eb259f4cd9a657c8f876d045baa4026b7fdb3a5e1ee6bb46e5105973"
    sha256 mojave:         "511990696c674dab6a9b1d180f987bb53a214e1bc889387d09dea134f6669216"
    sha256 x86_64_linux:   "dd024392296a37d55a74566cc7fd5299597ddc4a69347991c0bc7e200bf1d1c4"
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
