class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.4.tar.gz"
  sha256 "a3e83b1450222ffdbc7fa42e7171d530fcd568b6871158a489d86840ae130df7"

  bottle do
    sha256 "3a9a68530240d08c0de8cfd095494ac90f11f51fb393d0dbf1f4163b55df60c8" => :high_sierra
    sha256 "165e0cf363aaf1f8b98820f80acf0547e1885e67c06a19d0a5df2bd931116831" => :sierra
    sha256 "a2a33979133e731fa3fa3c54e52b3c88a35358131416a3d63be9277e2155d3b8" => :el_capitan
  end

  depends_on "libtool" => :run
  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "readline"

  def install
    system "./configure", "--disable-mh",
                          "--prefix=#{prefix}",
                          "--without-tokyocabinet"
    system "make", "PYTHON_LIBS=-undefined dynamic_lookup", "install"
  end

  test do
    system "#{bin}/movemail", "--version"
  end
end
