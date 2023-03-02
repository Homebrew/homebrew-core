class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.201.0.tar.gz"
  sha256 "74474c9cc47b87e6391895da6e23b9020086781b53dfab7585a099ac1da76568"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "674f29800e6b8af0beb50761e874f503e7a0546619ab8a616b6700e3da94c784"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df4eceb7f5ce4f855283d4e9db3fc0104726bcbbc5399b58829081a9b349158b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee3245aa64f41369bc593fbf6d5c99bcddd2e9ad6262f2bef7527301c0dae6c5"
    sha256 cellar: :any_skip_relocation, ventura:        "8771ca6a74f31198c778ae3e9a3d2efe5f909723ccf82dd963fea6774cce5c7f"
    sha256 cellar: :any_skip_relocation, monterey:       "d2f4322ed49e183e7f2520362bf1d83981d2d0f0c8f980c482a7b0534810f979"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bf101390ba48e9b760d2a7b15202e4fd50a1bc76ac2b7ca7165e0974592ad73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "888732c7d9f25fe740f0acb7cca3c0022dcb4aac6a29f23f17e7dab37aee06d3"
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
