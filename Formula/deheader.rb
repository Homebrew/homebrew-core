class Deheader < Formula
  include Language::Python::Shebang

  desc "Analyze C/C++ files for unnecessary headers"
  homepage "http://www.catb.org/~esr/deheader/"
  url "http://www.catb.org/~esr/deheader/deheader-1.7.tar.gz"
  sha256 "6856e4fa3efa664a0444b81c2e1f0209103be3b058455625c79abe65cf8db70d"
  license "BSD-2-Clause"
  revision 3
  head "https://gitlab.com/esr/deheader.git"

  livecheck do
    url :homepage
    regex(/href=.*?deheader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c796513f79f19f17be962e08802c9542d0dcddbe7fffdc44e2c66538c704a325"
  end

  depends_on "xmlto" => :build
  depends_on "python@3.10"

  on_linux do
    depends_on "libarchive" => :build
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "make"
    bin.install "deheader"
    man1.install "deheader.1"

    rewrite_shebang detected_python_shebang, bin/"deheader"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
