class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/refs/tags/v1.4.12.tar.gz"
  sha256 "438cccf785cc8ac1575a81ca606afdbb8a4de8f860136d9f26a1807b00903f5d"
  license "MIT"
  revision 1
  head "https://github.com/so-fancy/diff-so-fancy.git", branch: "next"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "17985db1f40e3f59947c1614a9d9f9d6d0feb358800da357370bd83a694ab955"
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
