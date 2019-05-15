class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.5.tar.gz"
  sha256 "c01ba9d05bf1ce7352373a529a7e7c7efc6ad9006c85651ffbc941dd03403af6"

  bottle do
    sha256 "086213ef133468e2b97c4d0cd65b919751127b86bac79633de0f4134b2393d53" => :mojave
    sha256 "9025ac552ffa4ec245af7d6db38a95eadb3876ff28146ba8dea4a954648d9798" => :high_sierra
    sha256 "b7447a61f03f813b4b862c7b0d7bc51007ff0e514107036f0dbdc2b67b852bcb" => :sierra
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
