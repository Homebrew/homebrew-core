class Libmxml < Formula
  desc "Mini-XML library"
  homepage "https://michaelrsweet.github.io/mxml/"
  url "https://github.com/michaelrsweet/mxml/releases/download/v4.0.6/mxml-4.0.6.tar.gz"
  sha256 "ec1af6f7a752f63649ad00cf7355cf36366ccf729658a1a4696270de8bd74854"
  license "Apache-2.0"
  head "https://github.com/michaelrsweet/mxml.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b26c5e30103ccf3cde2318342f04005b32746c3172ed11b05dbd0ffcb1138335"
    sha256 cellar: :any, arm64_tahoe:       "f1a73853f88ad5939b1ee35b19ab0a99a86bb2510d8b2e1be51444c2d0dbd309"
    sha256 cellar: :any, arm64_sequoia:     "72c5171a3de34db7a162fb5aa0b44c5db9fafa744b967fe77e1b4d706ce48414"
    sha256 cellar: :any, arm64_linux:       "b6c398dbcd40129bfe717049bc804081286bc0ef2ce8d0984dd61cf9673caab8"
    sha256 cellar: :any, x86_64_linux:      "f47fc4593704d533469508e90eed317cd2e4fe36b231093e0a95e8cbcfa44dd8"
  end

  depends_on "pkgconf" => :test

  deny_network_access!

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
