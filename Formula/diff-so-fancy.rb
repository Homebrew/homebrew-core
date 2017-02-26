require "language/node"

class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://registry.npmjs.org/diff-so-fancy/-/diff-so-fancy-0.11.3.tgz"
  sha256 "50a14c75831769fb524311e706f3abfaee9150d221a87947e2f1d0392ea95436"

  bottle do
    cellar :any_skip_relocation
    sha256 "95d00f3a8ba764b5b4d6dff98580f6da0ba10af473c59711134e60ab51780672" => :sierra
    sha256 "f147e2bf87cbdb65df2d3cd3ac864649a53287fce6123697e565b8e6978c4a2e" => :el_capitan
    sha256 "6a96d02b3d6ca2e8e9c622197a73f3060debce7a2cf5b66aa90da4d0468a9ad9" => :yosemite
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
