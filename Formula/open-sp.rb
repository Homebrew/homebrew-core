class OpenSp < Formula
  desc "SGML parser"
  homepage "https://openjade.sourceforge.io"
  url "https://downloads.sourceforge.net/project/openjade/opensp/1.5.2/OpenSP-1.5.2.tar.gz"
  sha256 "57f4898498a368918b0d49c826aa434bb5b703d2c3b169beb348016ab25617ce"

  bottle do
    rebuild 4
    sha256 "ed66b34bcf33e9b7908ec466dd66db245b1a2556c2778705d14c99f73f5038f0" => :catalina
    sha256 "0c34e7815d7b7f654210102518787bf4c07e6ef811bae5167967747a99b762ab" => :mojave
    sha256 "41deb89bf8fd39c9d99eb171039a949fba4e82eb86d674d2584ae70a0e3ecc73" => :high_sierra
    sha256 "77f282ed97f428763c7952365353a6b915ff3315d7808db73a51e785961e989c" => :sierra
    sha256 "03629f243a1598b2b26fc07f8b747c77b62efe88ce435d8e018167140d22b86e" => :el_capitan
  end

  depends_on "docbook" => :build
  depends_on "ghostscript" => :build
  depends_on "xmlto" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

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
