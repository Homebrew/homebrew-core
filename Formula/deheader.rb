class Deheader < Formula
  desc "Analyze C/C++ files for unnecessary headers"
  homepage "http://www.catb.org/~esr/deheader"
  url "http://www.catb.org/~esr/deheader/deheader-1.3.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/d/deheader/deheader_1.3.orig.tar.gz"
  sha256 "652c07bf1c7d5da7cf71c9889de11609c8cb2bd0c13122ad424f2c25da9e2e3b"
  head "https://gitlab.com/esr/deheader.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e778a60a99a3d5e87639e9ad48180288fd005e5c76859f62eb9efe04135892f" => :el_capitan
    sha256 "aef1aba1409357470bda97772407f1c3cf0221384aaa573a232fd31cf9d321bd" => :yosemite
    sha256 "041b73d0dc1f097d3cb5f43f5af4a647d8a926a28e331d9271341e59e5bb8d96" => :mavericks
  end

  depends_on "xmlto" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "make"
    bin.install "deheader"
    man1.install "deheader.1"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <string.h>
      int main(void) {
        printf("%s", "foo");
        return 0;
      }
    EOS
    assert_equal "121", shell_output("deheader test.c | tr -cd 0-9")
  end
end
