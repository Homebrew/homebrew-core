class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.5.tar.gz"
  sha256 "c01ba9d05bf1ce7352373a529a7e7c7efc6ad9006c85651ffbc941dd03403af6"

  bottle do
    sha256 "4534b7279eebc00daa33748b5dd13ca515f85027c7179620395d7f29245f03ee" => :mojave
    sha256 "fb9d692e4cca9b19fc8a58f3db09d1f69b52876209b20a678bf8a82405b81456" => :high_sierra
    sha256 "7f55d036e19237423f2a1d2cbf5e9415d10a97f10d462ed00ecfb157248a31a8" => :sierra
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
