class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.10.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.10.tar.gz"
  sha256 "1a4025280f504ff56269f0fc25859cfea20a39dd45d12abfffe1f89ee54e708a"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "2a0c02530447ce4edeeaab7b84cec370e342b02a5606eb36b6ab611d6a308eb9" => :catalina
    sha256 "dbdbd2b06de4ad016feaf7f89f3bd4536b205489476daac87e8a7e60e8350fd6" => :mojave
    sha256 "f03c50b72974082a31d51f2665786d723ab853b19ab3df35dd8a2b8c39e27901" => :high_sierra
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
