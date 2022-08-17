class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.185.0.tar.gz"
  sha256 "c091ad790bf2cfdbe668e7a03e10d23ba837a0055d2fbbdc2bfee7d9b01d80fb"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ded652e44afb37e0fb6c309049a0516dddff985f31b89a3f140a2e7d82a42e0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff7168d121cb8677a0d67db4f4cb4c05baa7234f534208d94fdb6dffa6e29a4a"
    sha256 cellar: :any_skip_relocation, monterey:       "738e27ef3f1d9c5f5c2ae2ebe353e6f6cab5fdf0214528eace621e9f25830c79"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cef69bb214987e4012c76bc850656b03115636c2c3cdb1ab2827de91a4f77df"
    sha256 cellar: :any_skip_relocation, catalina:       "f43286b3e1719eea80b58d56bf028f44840e381d0c015b4b47db78cefaa9e3d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5ecbfb42e3df72e16a1a0323644f7c768a5e862234e6b7b3143acc4993a417a"
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
