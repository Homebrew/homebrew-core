class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.211.0.tar.gz"
  sha256 "cd4cce3278a860fd7eab07ce51b1b8bdbb4f224535f373c0e16e8076ecd7d39e"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b31e3646b5dc2612a8b346440a2f20476a604a08e6c89699db0673b17ae10e38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5752112f65fcdfa2070ab4d32b909fdd91d0eef154ba2f06f3cd8911011e7c0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f00a8cca70643788efeacab5273d17ed08992a95b15a48d607f36d698855d18"
    sha256 cellar: :any_skip_relocation, ventura:        "12d795453ff3f195e4e24fe33d406ea9211ab444dbc5d3dd88ddce47cf776f24"
    sha256 cellar: :any_skip_relocation, monterey:       "ddbc1d1414b02c894c7d5d5398e11d8af67e13c6981220eae07131af1e23ee08"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a336315b28c20ed90336f8d585694cefaccfd596935e020b7a7b4796e3a2c86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e070fdab7f771b2f7513afe6f49f5fb24e52d4b48b4818e195e1e49e801181d"
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
