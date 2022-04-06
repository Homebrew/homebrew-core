class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.175.1.tar.gz"
  sha256 "80dc34e7cdd554c321cfee8dcc9f282884e6efd7ba32c41a39573c57ccdf8e08"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb2234b819f0ea40fc7cc5f46d1a3a3433658776d467473b3e15cd74dcda5773"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3509fabce0c4a7b4b0203376502a883fd13e044ae78ad0caf237bf9a998e5cd"
    sha256 cellar: :any_skip_relocation, monterey:       "6c4912d682f540e18df64e9cd5f40ed0e95bfa00151cae63e7c4010a1c7185a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "923a23bda524e0423f63f3b6b29f280231c410e97a9f892b5f9039e957df10db"
    sha256 cellar: :any_skip_relocation, catalina:       "368765505be277c7ac38a4a0eb779aa538b1e62163996a3bae24e6f0d3f0cfe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "601c052b75d48a96fd2a6eb202563e72255409e1b6866240e9f1ab29a3a6ae0f"
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
