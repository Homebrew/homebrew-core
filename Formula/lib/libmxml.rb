class Libmxml < Formula
  desc "Mini-XML library"
  homepage "https://michaelrsweet.github.io/mxml/"
  url "https://github.com/michaelrsweet/mxml/releases/download/v4.0.7/mxml-4.0.7.tar.gz"
  sha256 "5e2204b7271327e618ab181cf036d4d72dcc393201933060cd34d73d486ee5cc"
  license "Apache-2.0"
  head "https://github.com/michaelrsweet/mxml.git", branch: "master"

  bottle do
    manifest_sha256 "fef616dd021f3b5110b488dd4ff5a8350c6fece4d6dd13c7add68495ee17b3d8"
    sha256 cellar: :any, arm64_golden_gate: "2179d8141751c97570d245fec006fcbd587ccfe052aa7c79107d9b0a51f8ef0c"
    sha256 cellar: :any, arm64_tahoe:       "a0bb4fc788b770d96a4b7b923ab1a07338de7d70211b45dd5ebb0b7528bb13cd"
    sha256 cellar: :any, arm64_sequoia:     "19ecd215325f7080bb1229179f47b98ad57d62a27ca68ba0ba7bd19ab960aefb"
    sha256 cellar: :any, arm64_linux:       "7667c105825d1fa0c72aa09782ff844a39f6f9a78b5ea934ac4c1a27144d7bd9"
    sha256 cellar: :any, x86_64_linux:      "5f63e885d9ad57c57887ee89268c4bd7b0a3ec7d6fdd32efd036d6af62524869"
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
