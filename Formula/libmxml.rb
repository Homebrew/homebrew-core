class Libmxml < Formula
  desc "Mini-XML library"
  homepage "https://michaelrsweet.github.io/mxml/"
  url "https://github.com/michaelrsweet/mxml/releases/download/v3.2/mxml-3.2.tar.gz"
  sha256 "b894f6c64964f2e77902564c17ba00f5d077a7a24054e7c1937903b0bd42c974"
  license "Apache-2.0"
  head "https://github.com/michaelrsweet/mxml.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c83d4a6556c0da6f962e37b07874d22a90c388751fc0b46db669ea2603d4b5bb"
    sha256 cellar: :any,                 big_sur:       "70c41d09f15c8de8f93df010b73fe51211d262a86c69a25c0ea1028440267c01"
    sha256 cellar: :any,                 catalina:      "680142115002908ad936e6cc27b507056d10b91a4c6d5ca250480090be71e21b"
    sha256 cellar: :any,                 mojave:        "a8d373d3bef6a43d40ef8aed433257fbdc6ba7566b454565dcdeeb3b21290edc"
    sha256 cellar: :any,                 high_sierra:   "6717fbc8fb911a1a3b076c1cb1d80ab9ea010456810d14995346973543cdc2f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09b769b8d43721fd4b56a4044806fcbe2d7275d1f82e1067908690ecaa1d5f1f"
  end

  depends_on xcode: :build # for docsetutil

  def install
    system "./configure", "--disable-debug",
                          "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mxml.h>

      int main()
      {
        FILE *fp;
        mxml_node_t *tree;

        fp = fopen("test.xml", "r");
        tree = mxmlLoadFile(NULL, fp, MXML_OPAQUE_CALLBACK);
        fclose(fp);
      }
    EOS

    (testpath/"test.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <test>
        <text>I'm an XML document.</text>
      </test>
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmxml", "-o", "test"
    system "./test"
  end
end
