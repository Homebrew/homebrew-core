class Fop < Formula
  desc "XSL-FO print formatter for making PDF or PS documents"
  homepage "https://xmlgraphics.apache.org/fop/index.html"
  url "https://www.apache.org/dyn/closer.lua?path=xmlgraphics/fop/binaries/fop-2.9-bin.tar.gz"
  mirror "https://archive.apache.org/dist/xmlgraphics/fop/binaries/fop-2.9-bin.tar.gz"
  sha256 "b698bfba5d6dea9d01aafd94d1a1359e443ebfb6b2b9ea69c6ed2852ab554784"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "69e353f9fb01a721daa25ca0ef2df097a7f24de2025e43d8a912ea6bf2dc9a02"
  end

  depends_on "openjdk"

  resource "hyph" do
    url "https://downloads.sourceforge.net/project/offo/offo-hyphenation/2.2/offo-hyphenation-compiled.zip"
    sha256 "3b503122b488bd30f658e9757c3b3066dd7a59f56c3a9bbb3eaae2d23b7d883f"
  end

  def install
    rm_r(Dir["fop/*.bat"]) # Remove Windows files.
    libexec.install Dir["*"]

    executable = libexec/"fop/fop"
    executable.chmod 0555
    (bin/"fop").write_env_script executable, JAVA_HOME: Formula["openjdk"].opt_prefix

    resource("hyph").stage do
      (libexec/"fop/build").install "fop-hyph.jar"
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
