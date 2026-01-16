class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.296.1.tar.gz"
  sha256 "becf948d8086e6139541e3fd36f86af058145e3185cd2ecf31b83ef10092618a"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b20cf62c5bed7c544895b70cc00d9e583047021c1eff5ceca49ca1f37ac12756"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f87a665970d5b5325213a6e29b21a6c1f26f35f9ab78824b33aa4a4f8c235e0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d712ed32262bfcf601c9d685475f59cf8dd9bc88067a55dc933cfd96657d5dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e345f367468aab2445352d93871f94dfd8a0eeab05ab12b6fa0c27f69c2b462d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4496e4eb240bb107e363423c3369f8e5b1ce7a9118a99da563cdff36c96a56a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b422fc7686bcde02554822b8e6aae48d013456d84959589f2ff7b1ead6b83b4"
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
