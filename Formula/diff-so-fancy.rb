require "language/node"

class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://registry.npmjs.org/diff-so-fancy/-/diff-so-fancy-0.11.1.tgz"
  sha256 "c2824f4661d706ef9af7317fc253c123bc8f5d88f83732d880c4504309ae7a0f"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f62e9ae016e5e32ae3713516ecc4ee1ea81c0bc1055dfe0168c1ef41f0c7d5b" => :sierra
    sha256 "dc36875af0c049244294a3d55a0f7636b58c07da6a16a45b47b6e96faaecb661" => :el_capitan
    sha256 "4b1400d88283ea1e4b3a5ec1b0ce3c7c65152357f740cf84aaac97b721fa8707" => :yosemite
    sha256 "4db05f742f66f26115bc341c1e439d5c11ab4489fa479974a01d8ed15153e3ce" => :mavericks
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
