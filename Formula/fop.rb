class Fop < Formula
  desc "XSL-FO print formatter for making PDF or PS documents"
  homepage "https://xmlgraphics.apache.org/fop/index.html"
  url "https://www.apache.org/dyn/closer.cgi?path=/xmlgraphics/fop/binaries/fop-2.3-bin.tar.gz"
  sha256 "1d1984f3679ca165075d71e7c18679f00f97e21b453bf561c2847c3119c35993"

  bottle :unneeded

  depends_on :java => "1.6+"

  resource "hyph" do
    url "https://downloads.sourceforge.net/project/offo/offo-hyphenation-utf8/0.1/offo-hyphenation-fop-stable-utf8.zip"
    sha256 "0b4e074635605b47a7b82892d68e90b6ba90fd2af83142d05878d75762510128"
  end

  def install
    rm_rf Dir["fop/*.bat"] # Remove Windows files.
    libexec.install Dir["*"]

    executable = libexec/"fop/fop"
    executable.chmod 0555
    bin.write_exec_script executable

    resource("hyph").stage do
      (libexec/"build").install "fop-hyph.jar"
    end
  end

  test do
    (testpath/"test.xml").write "<name>Homebrew</name>"
    (testpath/"test.xsl").write <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <xsl:stylesheet version="1.0"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:fo="http://www.w3.org/1999/XSL/Format">
        <xsl:output method="xml" indent="yes"/>
        <xsl:template match="/">
          <fo:root>
            <fo:layout-master-set>
              <fo:simple-page-master master-name="A4-portrait"
                    page-height="29.7cm" page-width="21.0cm" margin="2cm">
                <fo:region-body/>
              </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:page-sequence master-reference="A4-portrait">
              <fo:flow flow-name="xsl-region-body">
                <fo:block>
                  Hello, <xsl:value-of select="name"/>!
                </fo:block>
              </fo:flow>
            </fo:page-sequence>
          </fo:root>
        </xsl:template>
      </xsl:stylesheet>
    EOS
    system bin/"fop", "-xml", "test.xml", "-xsl", "test.xsl", "-pdf", "test.pdf"
    assert_predicate testpath/"test.pdf", :exist?
  end
end
