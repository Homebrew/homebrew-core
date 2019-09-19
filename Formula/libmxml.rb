class Libmxml < Formula
  desc "Mini-XML library"
  homepage "https://michaelrsweet.github.io/mxml/"
  url "https://github.com/michaelrsweet/mxml/releases/download/v3.1/mxml-3.1.tar.gz"
  sha256 "1ac8d252f62f9dc2b2004518c70d2da313bdfcd92b8350e215f46064a34b52fc"
  head "https://github.com/michaelrsweet/mxml.git"

  bottle do
    cellar :any
    sha256 "f8e186285e66c760f033ab4205cfa5d05a48d3b5ac2a668c0f3cd4572c0fd151" => :mojave
    sha256 "bf35de7007c525ef4e179ec3e89df8656b9a206f9390df068585361d90cbd3b6" => :high_sierra
    sha256 "044434b96bcf9a3097e28c4e85fa5e1e558f2b2dc62c7e8eba6363c664924b68" => :sierra
  end

  depends_on :xcode => :build # for docsetutil

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
