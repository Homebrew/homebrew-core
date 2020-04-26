class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v1.3.0.tar.gz"
  sha256 "d37242282935aea2bdafee9813601f2c42e439ffac0f87c68318db790d136a0c"
  head "https://github.com/so-fancy/diff-so-fancy.git", :branch => "next"

  bottle :unneeded

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
