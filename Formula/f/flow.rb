class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.313.0.tar.gz"
  sha256 "768603eb19e9176ddbef9574f6f8bed625748aa491d8b16fb9faeb8c9ca12475"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f08fccb6594ae6c6046955ce0250d1c8085a7c607b94c8fa4c02f77d2509d7bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bc1c8a2f7a0a303e52b273a9064defdb63823553159763f3f0f3f8138f7c9c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dffa19b798af4f91cee2c7395d6a681adba6dfbf15e3f0f0e1220e3aca28397"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c18cec9b6e9e204bf9012f92abe6fea8d1af4f2b415f8d76b13de236d76492c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "917f5d71ee7c4eee3adbadc8da48d27837410209ed4fd7f4f87154e786d2255d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07475430ad3769318297f48fb44c432d488ce9320859f1e763bbb0d845b0c9d0"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system bin/"flow", "init", testpath
    (testpath/"test.js").write <<~JS
      /* @flow */
      var x: string = 123;
    JS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
