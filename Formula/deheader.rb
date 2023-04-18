class Deheader < Formula
  include Language::Python::Shebang

  desc "Analyze C/C++ files for unnecessary headers"
  homepage "http://www.catb.org/~esr/deheader/"
  url "http://www.catb.org/~esr/deheader/deheader-1.10.tar.gz"
  sha256 "909d2683a3e62da54bfc660814b4d8af93f582e23858810cc41bfa081571f593"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?deheader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "67fb3c4990162be0ba10c9c6a934d6826a43fcf17bcd876d91777e408ad7258c"
  end

  head do
    url "https://gitlab.com/esr/deheader.git", branch: "master"
    depends_on "xmlto" => :build
  end

  depends_on "python@3.11"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
      system "make"
    end

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
