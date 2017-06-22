require "language/node"

class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://registry.npmjs.org/diff-so-fancy/-/diff-so-fancy-1.0.0.tgz"
  sha256 "13d8d6f8dd3b3100ab48de04df593daf137e21c28d1e10082b75f723f9b182b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "538a3a546b2fc6091a455cca78f6349c1efffef85646d336bda25dd857abc625" => :sierra
    sha256 "6d6abeec030b9d3ddf9bb9d65a731ad4a6495707fb8be5859a8f3f788227d536" => :el_capitan
    sha256 "e4466cd5508fddcda748ceed7e01f0be45e10499ce16f92c0d4928c8028d5708" => :yosemite
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
