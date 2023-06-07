class Libabw < Formula
  desc "Library for parsing AbiWord documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libabw"
  url "https://dev-www.libreoffice.org/src/libabw/libabw-0.1.3.tar.xz"
  sha256 "e763a9dc21c3d2667402d66e202e3f8ef4db51b34b79ef41f56cacb86dcd6eed"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6ad85dc29ed6262c148bd70631ea06886e1e7fce5d6c8abf66b9486d85e8055b"
    sha256 cellar: :any,                 arm64_monterey: "32cfa5aeedc8f7bff68a474f0bb6cc8d3501b301bb57c3a13c2a3bf535bedada"
    sha256 cellar: :any,                 arm64_big_sur:  "7218127205f7f8cc1032b769e29ec9d12aba7d24c919b5afecde92b5e877953d"
    sha256 cellar: :any,                 ventura:        "8e7b0a87423c367ac899cb7459b8d28604f3f75988de7ba3daea77ef2bf70bb0"
    sha256 cellar: :any,                 monterey:       "79862a34d53145dcd6c2435578500f6fa01f8697e294d20001430d07ee4fcde6"
    sha256 cellar: :any,                 big_sur:        "cb183a618afaa39fca1c827c37d3e93c163b160af94290a65f87ca226a129415"
    sha256 cellar: :any,                 catalina:       "01cfa53a2e623a95444477cc924aaa67f362dcf18b5c0780ed271284fa66174b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3080aed8222be7eb35addd5e04c18ed6c0b322832059a07d029ab1c814c2190e"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "librevenge"

  uses_from_macos "gperf" => :build
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--without-docs"
    system "make", "install"
  end

  test do
    (testpath/"test.abw").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE abiword PUBLIC "-//ABISOURCE//DTD AWML 1.0 Strict//EN"
        "http://www.abisource.com/awml.dtd">
      <abiword template="false" styles="unlocked"
      xmlns:fo="http://www.w3.org/1999/XSL/Format"
      xmlns:math="http://www.w3.org/1998/Math/MathML" xid-max="2"
      xmlns:dc="http://purl.org/dc/elements/1.1/" fileformat="1.0"
      xmlns:svg="http://www.w3.org/2000/svg"
      xmlns:awml="http://www.abisource.com/awml.dtd"
      xmlns="http://www.abisource.com/awml.dtd"
      xmlns:xlink="http://www.w3.org/1999/xlink" version="0.99.2" xml:space="preserve"
      props="dom-dir:ltr; document-footnote-restart-section:0;
      document-endnote-type:numeric; document-endnote-place-enddoc:1;
      document-endnote-initial:1; lang:en-US; document-endnote-restart-section:0;
      document-footnote-restart-page:0; document-footnote-type:numeric;
      document-footnote-initial:1; document-endnote-place-endsection:0">

      <metadata>
      <m key="dc.format">application/x-abiword</m>
      <m key="abiword.generator">AbiWord</m>
      </metadata>
      <history version="1" edit-time="62" last-saved="1228521545"
      uid="8dc39562-c328-11dd-90a9-a11565aba146">
      <version id="1" started="1228521545" uid="b2ba6abc-c328-11dd-90a9-a11565aba146"
      auto="0" top-xid="2"/>
      </history>
      <styles>
      <s type="P" name="Normal" followedby="Current Settings"
      props="font-family:Times New Roman; margin-top:0pt; color:000000;
      margin-left:0pt; text-position:normal; widows:2; font-style:normal;
      text-indent:0in; font-variant:normal; font-weight:normal; margin-right:0pt;
      font-size:12pt; text-decoration:none; margin-bottom:0pt; line-height:1.0;
      bgcolor:transparent; text-align:left; font-stretch:normal"/>
      </styles>
      <pagesize pagetype="Letter" orientation="portrait" width="8.500000"
      height="11.000000" units="in" page-scale="1.000000"/>
      <section xid="1" props="page-margin-footer:0.5in; page-margin-header:0.5in">
      <p style="Normal" xid="2">
      <c props="lang:en-US">This </c><c props="font-weight:bold;
      lang:en-US">word</c><c props="lang:en-US"> is bold.</c></p>
      </section>
      </abiword>
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <stdio.h>
      #include <string.h>
      #include <librevenge-stream/librevenge-stream.h>
      #include <librevenge-generators/librevenge-generators.h>
      #include <libabw/libabw.h>

      int main() {
        librevenge::RVNGFileStream input("#{testpath}/test.abw");
        if (!libabw::AbiDocument::isFileFormatSupported(&input)) {
          printf("invalid file\\n");
          return 1;
        }

        librevenge::RVNGString document;
        librevenge::RVNGTextTextGenerator documentGenerator(document, false);
        if (!libabw::AbiDocument::parse(&input, &documentGenerator)) {
          printf("failed to parse file\\n");
          return 1;
        }

        printf("ok\\n");
        return 0;
      }
    EOS

    assert_equal shell_output("#{bin}/abw2text test.abw"), "This word is bold.\n"

    args = %W[
      -I#{include/"libabw-0.1"} -I#{Formula["librevenge"].opt_include/"librevenge-0.0"}
      -L#{lib} -L#{Formula["librevenge"].opt_lib}
      -labw-0.1 -lrevenge-stream-0.0 -lrevenge-generators-0.0 -lrevenge-0.0
    ]
    system ENV.cxx, "test.cpp", *args, "-o", "test"
    assert_equal shell_output(testpath/"test"), "ok\n"
  end
end
