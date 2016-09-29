class Deheader < Formula
  desc "Analyze C/C++ files for unnecessary headers"
  homepage "http://www.catb.org/~esr/deheader"
  url "http://www.catb.org/~esr/deheader/deheader-1.4.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/deheader/deheader_1.4.orig.tar.gz"
  sha256 "ee42443cda39d2827a2cee551412d54cd740f0ef0d43b6b53c9ae38bc19887e5"
  head "https://gitlab.com/esr/deheader.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "27af781d671ff741a5bf53a0d3a9be10a66c57c37c41dfbed03377ee2933f851" => :sierra
    sha256 "f38d104c5934262c97c51c45493dd8c0bba2b3147f3451102f4fb1d47bf0f49d" => :el_capitan
    sha256 "3235073d6a98c5fe8001563c2d09ddce3de7808fe8c5618cc60f71be1491423a" => :yosemite
    sha256 "3235073d6a98c5fe8001563c2d09ddce3de7808fe8c5618cc60f71be1491423a" => :mavericks
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
    assert_equal "121", shell_output("#{bin}/deheader test.c | tr -cd 0-9")
  end
end
