class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.4.tar.gz"
  sha256 "a3e83b1450222ffdbc7fa42e7171d530fcd568b6871158a489d86840ae130df7"

  bottle do
    sha256 "e83aeb8ac4b27c735b135684a50f39e675752968369bca3754c7fcca1c55e848" => :mojave
    sha256 "bbd0305336adc02ee5da9d5cd84d267212fad59e6aa67e7d8564531eeaaabad7" => :high_sierra
    sha256 "241d546b7d97fc8cc8150b61d3a7c1770868f235ffe76634a08e98ae9b6daefc" => :sierra
    sha256 "752f777cafe9eb7434c900882bdb7eda9cf100d5f3a177a05ae4e164aa98c2a4" => :el_capitan
  end

  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "libtool"
  depends_on "readline"

  def install
    system "./configure", "--disable-mh",
                          "--prefix=#{prefix}",
                          "--without-guile",
                          "--without-tokyocabinet"
    system "make", "PYTHON_LIBS=-undefined dynamic_lookup", "install"
  end

  test do
    system "#{bin}/movemail", "--version"
  end
end
