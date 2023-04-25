class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.204.1.tar.gz"
  sha256 "55f9a549eb23e62f77c68c3bb745b411f5beedbac929bf60a46416654638c2a5"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81a959f80799d2c23c68c7f3382f5d11161fb1973ab9cda38d5713ee8dc7a6ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc468b0be7de84765d94f9aa0fbd0de1afdfe102f6caa41e89adf2f5fb5a95ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1292183e245b6ae890e2412acbc7382a33c8479e5280883240f0b4f457424668"
    sha256 cellar: :any_skip_relocation, ventura:        "8c638cb7e771c2ef77f46ec078583e3bd9db775daa8d7f23c9fccbefbe2168a1"
    sha256 cellar: :any_skip_relocation, monterey:       "812548928760069dc55d8374ddacd158aa13acaa8fb7b4cc2027313c3814e07f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f734e2674610b2a6b6210871b9385bdb70604210ea87fb39bfe6a9120d582701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "093b03d41feddf22c5f4763fdfd1edce3588b5e5008c9531d8036ce55d9d156f"
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
