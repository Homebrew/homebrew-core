class Deheader < Formula
  include Language::Python::Shebang

  desc "Analyze C/C++ files for unnecessary headers"
  homepage "http://www.catb.org/~esr/deheader/"
  url "https://gitlab.com/esr/deheader/-/archive/1.13/deheader-1.13.tar.bz2"
  sha256 "9d048b84c6459b44ecc8cd56d1bc407dc30419eb4c7263311f887a4587eb9f4b"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/deheader.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6f8f29cb6ec6a901c6beb182a2d98a1e4dc767339f0110e05d995ac8367a443e"
  end

  depends_on "asciidoctor" => :build

  uses_from_macos "python"

  def install
    system "asciidoctor", "-b", "manpage", "deheader.adoc"

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
