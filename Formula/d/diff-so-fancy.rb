class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/refs/tags/v1.4.10.tar.gz"
  sha256 "9df1e7b5c47f1f70ea5d23b18a5994c431548029448465256a93b3b7cfeb0b4a"
  license "MIT"
  head "https://github.com/so-fancy/diff-so-fancy.git", branch: "next"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9981ccb3542f9b0044e1719a3a9b0d32d947a53e63f0a34e25caada4889861a9"
  end

  def install
    libexec.install "diff-so-fancy", "lib"
    bin.install_symlink libexec/"diff-so-fancy"
  end

  test do
    diff = <<~EOS
      diff --git a/hello.c b/hello.c
      index 8c15c31..0a9c78f 100644
      --- a/hello.c
      +++ b/hello.c
      @@ -1,5 +1,5 @@
       #include <stdio.h>

       int main(int argc, char **argv) {
      -    printf("Hello, world!\n");
      +    printf("Hello, Homebrew!\n");
       }
    EOS
    assert_match "modified: hello.c", pipe_output(bin/"diff-so-fancy", diff, 0)
  end
end
