class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.11.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.11.tar.gz"
  sha256 "7e507b28270da2771eb18aaca1648ef637a668bfaa41b50990e775dcd6c6c4af"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "2bd00bf5866505474733869b501295dfa0cd4790bb958e2ddf797c54cc4e3dff" => :big_sur
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
