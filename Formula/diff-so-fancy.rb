require "language/node"

class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://registry.npmjs.org/diff-so-fancy/-/diff-so-fancy-0.11.2.tgz"
  sha256 "4e33af7f166919dc4a39a212259fccc7a4ff2f73d7366a5298744f97f1a49bf8"

  bottle do
    cellar :any_skip_relocation
    sha256 "adba36ed17880a80cd5ccfa74f5d24f804642c19db79657a565a4903ac6b9c8f" => :sierra
    sha256 "bee8bbbd22db737d47a124362040262b19d1cec2fb409fcdadadd9687af049d1" => :el_capitan
    sha256 "1dd0562ea0f0329ada0671410681ca7e31e04db2163c58675528ef80924268b8" => :yosemite
  end

  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    diff = <<-EOS.undent
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
