class Deheader < Formula
  include Language::Python::Shebang

  desc "Analyze C/C++ files for unnecessary headers"
  homepage "http://www.catb.org/~esr/deheader/"
  url "http://www.catb.org/~esr/deheader/deheader-1.8.tar.gz"
  sha256 "ebf144b441cc12ff5003e3e36c16e772382a153968c44334d5d6a892b44cab06"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?deheader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b32980eca30764c8a936e099452e952224ece8f51f5185e5862c746bd28eda15"
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
