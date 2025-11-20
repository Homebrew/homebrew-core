class Deheader < Formula
  include Language::Python::Shebang

  desc "Analyze C/C++ files for unnecessary headers"
  homepage "http://www.catb.org/~esr/deheader/"
  url "http://www.catb.org/~esr/deheader/deheader-1.11.tar.gz"
  sha256 "553fd064a0e46ff5a88efd121e68d7613c5ffa405d1e7f775ce03111eae30882"
  license "BSD-2-Clause"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2caa30192b0b43e4892d9742d759b65d3cee8109c87e7169fd371a896cfd424e"
  end

  head do
    url "https://gitlab.com/esr/deheader.git", branch: "master"
    depends_on "xmlto" => :build
  end

  uses_from_macos "python"

  def install
    system "make", "XML_CATALOG_FILES=#{etc}/xml/catalog" if build.head?

    bin.install "deheader"
    man1.install "deheader.1"

    rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"deheader"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <string.h>
      int main(void) {
        printf("%s", "foo");
        return 0;
      }
    C
    assert_equal "121", shell_output("#{bin}/deheader test.c | tr -cd 0-9")
  end
end
