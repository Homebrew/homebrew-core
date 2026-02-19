class Deheader < Formula
  include Language::Python::Shebang

  desc "Analyze C/C++ files for unnecessary headers"
  homepage "http://www.catb.org/~esr/deheader/"
  url "https://gitlab.com/esr/deheader/-/archive/1.11/deheader-1.11.tar.bz2"
  sha256 "0f21ee3d84327e0776632d133129f64354e98c547a3d752869e7945205be57f2"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/deheader.git", branch: "master"

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

  depends_on "xmlto" => :build

  uses_from_macos "python"

  def install
    system "make", "XML_CATALOG_FILES=#{etc}/xml/catalog"

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
