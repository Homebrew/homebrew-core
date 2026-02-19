class Libabw < Formula
  desc "Library for parsing AbiWord documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libabw"
  url "https://dev-www.libreoffice.org/src/libabw/libabw-0.1.3.tar.xz"
  sha256 "e763a9dc21c3d2667402d66e202e3f8ef4db51b34b79ef41f56cacb86dcd6eed"
  license "MPL-2.0"
  revision 1

  livecheck do
    url "https://dev-www.libreoffice.org/src/libabw/"
    regex(/href=.*?libabw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "94f750ee7bbbf84e58e7673ab8c00d6f5ac7805e3866887ef3a598f10465d555"
    sha256 cellar: :any,                 arm64_sequoia: "615103d929d3d41b86505ec51bca88f383c9a890588bd6cfa1ac17de264e2575"
    sha256 cellar: :any,                 arm64_sonoma:  "36fd000ef3d1a511d89e6f050465b3dbdc6ced760615222779812ea836df25d9"
    sha256 cellar: :any,                 sonoma:        "5874a09fd09d99442394994ce591cdde79b201131e1f33c5268ebef8b0f3d02f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d5c1ad4d34c3dbab41b53d369abbe5bda59801caed9e238de74a12a04d18bb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e3863e042c26afed865f3857ae6b63054bd082b829bdf7f9ea6118aa8a1ae94"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "librevenge"

  uses_from_macos "gperf" => :build
  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules", "--without-docs", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.abw").write <<~XML
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
    XML

    (testpath/"test.cpp").write <<~CPP
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
    CPP

    assert_equal "This word is bold.\n", shell_output("#{bin}/abw2text test.abw")

    args = %W[
      -I#{include/"libabw-0.1"} -I#{Formula["librevenge"].opt_include/"librevenge-0.0"}
      -L#{lib} -L#{Formula["librevenge"].opt_lib}
      -labw-0.1 -lrevenge-stream-0.0 -lrevenge-generators-0.0 -lrevenge-0.0
    ]
    system ENV.cxx, "test.cpp", *args, "-o", "test"
    assert_equal "ok\n", shell_output(testpath/"test")
  end
end
