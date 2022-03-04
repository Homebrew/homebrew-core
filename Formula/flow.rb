class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.173.0.tar.gz"
  sha256 "e7536be16211e338a792a8818c377f06780cb0524f9208b666b3272ca0044f77"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3a577b51d47c399178feabfa3a1be0da34cb2e61bc7e44fda37f052ce6201d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2dc114e21faae4770c7c95fd5c6b1f83c6d5250b6a3a8cb4108f6e0337f62c0"
    sha256 cellar: :any_skip_relocation, monterey:       "c7bb181f22b3046296e12caa40776f6371a9c70e4294a8906bdf15606d1ed7dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "44cc92d952db9e2a89a61382da4e286e102ff05581f0b675f892ebf09285220a"
    sha256 cellar: :any_skip_relocation, catalina:       "90699556527ea2bcba2947aa31238599d3fe7c41bb7cc2a8a853295fd7983f0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af1833c1bc6e9664951858b57bdf9c5c7af205d5953bbbc3a13a1c1b75431508"
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
