class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/refs/tags/v1.4.14.tar.gz"
  sha256 "d09a648825ae2d18fa212ac897cc03f92637b3d547df599ee215f2c56ae87659"
  license "MIT"
  head "https://github.com/so-fancy/diff-so-fancy.git", branch: "next"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7d41a32350b7b648fe09bdb7ec135d3426d84fd2be2f7aff60090591eb0e6e1a"
  end

  def install
    libexec.install "diff-so-fancy", "lib"
    bin.install_symlink libexec/"diff-so-fancy"
  end

  test do
    diff = <<~DIFF
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
    DIFF
    assert_match "modified: hello.c", pipe_output(bin/"diff-so-fancy", diff, 0)
  end
end
