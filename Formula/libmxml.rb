class Libmxml < Formula
  desc "Mini-XML library"
  homepage "https://michaelrsweet.github.io/mxml/"
  url "https://github.com/michaelrsweet/mxml/releases/download/v3.3.1/mxml-3.3.1.tar.gz"
  sha256 "0c663ed1fe393b5619f80101798202eea43534abd7c8aff389022fd8c1dacc32"
  license "Apache-2.0"
  head "https://github.com/michaelrsweet/mxml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dc96370d86c83265e3effd6049c143dddb4248382d727642ceb65a66532588de"
    sha256 cellar: :any,                 arm64_big_sur:  "6e2b3cc9d77fe87f0ef87f01d8a18929b651dd139c8a6fba17d3385eabd44070"
    sha256 cellar: :any,                 monterey:       "3af6abe72cb8368988ded65b825947ddd3b979c04da8f8f38a3200629673f428"
    sha256 cellar: :any,                 big_sur:        "72ebcbbb662dc0fdcde53048ff12a98a11f6a4a134e91eecc82605bf384e2ce3"
    sha256 cellar: :any,                 catalina:       "085ea14c9ffe2c4318167bfe70a597ec75ae7efb93f6720ae45db536285d53c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c82b42cb4d23f082638ce0e4314e378052f361d73a35c85389fe2419ee13aff5"
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
