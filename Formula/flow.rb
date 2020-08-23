class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.132.0.tar.gz"
  sha256 "468c8502b14e8626d7aeb82e19db14acb1fbcec161d0784bc55263e63e67e907"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33df21d27d8e62bef9f727b22590753ad6dfce313b17e6e54b5f5c957a0b9e6f" => :catalina
    sha256 "8581fb1861082a3949dbef89ebe98760612077da88c2a96ee8a2be8ffc4422dc" => :mojave
    sha256 "8237240fc398c730ef3e3a5406de24229d03e3a0dad4a15cc4476ec8ec251486" => :high_sierra
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
