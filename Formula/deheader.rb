class Deheader < Formula
  include Language::Python::Shebang

  desc "Analyze C/C++ files for unnecessary headers"
  homepage "http://www.catb.org/~esr/deheader"
  url "http://www.catb.org/~esr/deheader/deheader-1.7.tar.gz"
  sha256 "6856e4fa3efa664a0444b81c2e1f0209103be3b058455625c79abe65cf8db70d"
  license "BSD-2-Clause"
  revision 2
  head "https://gitlab.com/esr/deheader.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d1fade275b69f47542d60cd80ce9b89b092e054954f41c5dc71626a737e23b3" => :big_sur
    sha256 "5269db101973a43a04b1df3795c29b843cdb3ccb2e6fa91e55b7cc313579e6b8" => :arm64_big_sur
    sha256 "c90653b7e27554f27b48ea49cef85d433320ee50a6ca63b0e899a69d65f61074" => :catalina
    sha256 "a2f353a857e4fa0fecaf81e750bf9fd97ee8893e8e65f185f01c3c648f310724" => :mojave
    sha256 "78ca1d70d0f500b332964630528f2110534d3d8a1eb89e01c9b6bfa4ad0dd0f0" => :high_sierra
  end

  depends_on "xmlto" => :build
  depends_on "python@3.9"

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
