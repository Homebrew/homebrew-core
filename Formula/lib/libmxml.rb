class Libmxml < Formula
  desc "Mini-XML library"
  homepage "https://michaelrsweet.github.io/mxml/"
  url "https://github.com/michaelrsweet/mxml/releases/download/v4.0.4/mxml-4.0.4.tar.gz"
  sha256 "c8d1728d6ccf71a862a1538bd5e132daa2181bb42fe14b078baa2ec1510c0150"
  license "Apache-2.0"
  head "https://github.com/michaelrsweet/mxml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f4b0dd844eb4bcbaa18bac4ff1a09791661681a1257d4d3a02af9673440c7d2"
    sha256 cellar: :any,                 arm64_sequoia: "82e19bced76d7f6c051d518d66986e09141eb0e469b96c1a07f846a8a76b38ae"
    sha256 cellar: :any,                 arm64_sonoma:  "f6ae2142da610a2347bab6180d96eeacc4a93316069593bd43b4a042e555fbe2"
    sha256 cellar: :any,                 arm64_ventura: "f0f7b03ef861dc93ad8460a80d1438e77d1fa257b9383777a4e2adae9dd2f3b3"
    sha256 cellar: :any,                 sonoma:        "cd8ed5ff1205d43cee4b76a4d1dd344657834556fc20297dce128f3d71917e11"
    sha256 cellar: :any,                 ventura:       "af8cf17432554379cba89524143512b53c44f4022bf547a7f1d0e6166216939b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03c82073c6046eba93252707914149e70ba8ff2c4d7a1822c7721c2c7dde8fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dc29cb18206b980b121c3a114f8c86114a5dcead1b2ae80e0b7eea78c17f0e4"
  end

  depends_on "pkgconf" => :test

  def install
    system "./configure", "--enable-shared", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <mxml.h>

      int main()
      {
        FILE *fp;
        mxml_node_t *tree;

        fp = fopen("test.xml", "r");
        tree = mxmlLoadFile(NULL, NULL, fp);
        fclose(fp);
      }
    C

    (testpath/"test.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <test>
        <text>I'm an XML document.</text>
      </test>
    XML

    flags = shell_output("pkgconf --cflags --libs mxml4").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
