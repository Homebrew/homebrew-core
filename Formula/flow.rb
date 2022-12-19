class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.196.1.tar.gz"
  sha256 "60c29d6b6fb3aeb00c6e52562ae12dcfd68a219b0fa36450b96f661f3ad11287"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ca78ac7362092d689ffd707409cd32594b7c27239a4a744303af366a4696769"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c7593c1e2c24a9a0f4d01618a8c2dceae36b280d5fb9d339d8daaa2a6da73f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d812436fefa37e97d9195d925aba9365ba86db4082645b9774bf6f0a215a069"
    sha256 cellar: :any_skip_relocation, ventura:        "47e53a7b331afe836cf29a146b0f2a513f52541a264a698fb04be6f78bd6611a"
    sha256 cellar: :any_skip_relocation, monterey:       "b6ed7f29fc10229f6cf212984e5bd6972af82417155c7c6bcd2a6467b75c8f42"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f377dde16ed4cb6a39a6afa6cd30455488d0fa1997a0792432fd931664a9d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce7c01c7c056eadc051d024ea63b4f37e466c8753be4d83c42145b8580d301cb"
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
