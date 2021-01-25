class OpenSp < Formula
  desc "SGML parser"
  homepage "https://openjade.sourceforge.io"
  url "https://downloads.sourceforge.net/project/openjade/opensp/1.5.2/OpenSP-1.5.2.tar.gz"
  sha256 "57f4898498a368918b0d49c826aa434bb5b703d2c3b169beb348016ab25617ce"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    rebuild 5
    sha256 "50109cdb514313693454259ba30f90f550618d48a1cc71df55ed04343d0cf641" => :big_sur
    sha256 "032676f1cd5c4bc0c1368cdf08bfe9a8b6df8f2c26ee4367c4a1285ab4fadc3a" => :arm64_big_sur
    sha256 "1b2c18d6cdcd99d387770eaa14a773bb3edec5b22984ac75f3b07a181916f18f" => :catalina
    sha256 "47a3595b023164a54f73009f5d0a1bd092355f7c5b357cb86e1ec781b101bcb8" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook" => :build
  depends_on "ghostscript" => :build
  depends_on "libtool" => :build
  depends_on "xmlto" => :build
  depends_on "gettext"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # The included ./configure file is too old to work with Xcode 12
    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-http",
                          "--enable-default-catalog=#{etc}/sgml/catalog"

    system "make", "pkgdatadir=#{share}/sgml/opensp", "install"
  end

  test do
    (testpath/"eg.sgml").write <<~EOS
      <!DOCTYPE TESTDOC [

      <!ELEMENT TESTDOC - - (TESTELEMENT)+>
      <!ELEMENT TESTELEMENT - - (#PCDATA)>

      ]>
      <TESTDOC>
        <TESTELEMENT>Hello</TESTELEMENT>
      </TESTDOC>
    EOS

    system "#{bin}/onsgmls", "--warning=type-valid", "eg.sgml"
  end
end
