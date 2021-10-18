class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.162.1.tar.gz"
  sha256 "257d7226443283e92f1e5ea57d136790857de1ce2b31761b501cf9191000d2ec"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bb504d7b6e4105308a9f5a78d7feb62c8b770e527584a64fe10c6579ee1ca398"
    sha256 cellar: :any_skip_relocation, big_sur:       "d675d750c04b277bc72c01fbe498de69ff02b162eb43a6f9fbc1597ff8d28b0c"
    sha256 cellar: :any_skip_relocation, catalina:      "f65e6deee8be2ca4821294673ae248879e2765db58a6352e5e585d8d86ea9c7d"
    sha256 cellar: :any_skip_relocation, mojave:        "926c1a7753bd85a812ad36eaf22842967c148f40fca26bc9d619483b41414792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62871f515e4a901c10104f98bef498fc2853e12214ba4cd06830240b75099897"
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
