require "language/node"

class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://registry.npmjs.org/diff-so-fancy/-/diff-so-fancy-1.0.0.tgz"
  sha256 "13d8d6f8dd3b3100ab48de04df593daf137e21c28d1e10082b75f723f9b182b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbb9b162c89bec116039e2849656fb253e2ecbbcd7973ba3d7b444e978c969a3" => :sierra
    sha256 "83cd8afe3628eab0a9ddcb2a4326a935279abb24e4409001eedcf1cee81342db" => :el_capitan
    sha256 "643d937586cc3e4bbe6d9189f6ef1f0a118b89b10dff5870d26d077edc06fb92" => :yosemite
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
