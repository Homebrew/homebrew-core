class Deheader < Formula
  include Language::Python::Shebang

  desc "Analyze C/C++ files for unnecessary headers"
  homepage "http://www.catb.org/~esr/deheader/"
  url "https://gitlab.com/esr/deheader/-/archive/1.12/deheader-1.12.tar.bz2"
  sha256 "08ca718429db0d3fbe4388d62239d6604a08f979a5421fc4f1a1b55cb688a4d3"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/deheader.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a50361d052ca4a600d876ef7f12a4286551f3bbe2fe72645d8c856e98aa3c230"
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
