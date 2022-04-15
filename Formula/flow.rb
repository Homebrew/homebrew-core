class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.176.2.tar.gz"
  sha256 "385ab3bf00a22f319570dd1f9fd49cf7398404a9bfa3fc009ed3652b179695b2"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27df768b8f2fb2e2a71b297e0f939b2172745dd7f61803f98807f2e14b1a5161"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0943722b350e844db4698b59ad97104a5e209e3f4ad25e8dd1613b1e2eefe46e"
    sha256 cellar: :any_skip_relocation, monterey:       "5715998eeb3b25b56582ff581aa83f7b52bb5499f442345137f8a4894b794f7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bb9b11117cc81dd362202c3115404b78d318ee266f7e156257cd96c59731e39"
    sha256 cellar: :any_skip_relocation, catalina:       "719574961344de7a234d5c26261f620376b24d035d3e7d844c37f004c2a1aacc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e010aa0217c141fd7510aa151918fbec78b49312f563ce12515231c5a710437"
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
