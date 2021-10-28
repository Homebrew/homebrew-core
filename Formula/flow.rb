class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.163.0.tar.gz"
  sha256 "5400883265b0db83070b758b484c500224a6ec8fc4b09edf067ff630fb9e8da7"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c8cf4c33a20f7ffcb00e5585e56e84dc3e6c61a44b8374f621082ed5cb0b3b6d"
    sha256 cellar: :any_skip_relocation, big_sur:       "b6518ac18fb095f41d837b166f9de43af8380fc829209156ad40aee451c249d2"
    sha256 cellar: :any_skip_relocation, catalina:      "c38ac9e241bd0677e1c6e811e9baddf0d62fe94cc000bf16de0e2a429a58285b"
    sha256 cellar: :any_skip_relocation, mojave:        "f6fdd64e3c53b879446d94a6202a72129c7ca5d300b6ee7afb11383001c19926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcf8c8d22c56e34d2c22344b8a7a54d2f33404206a95e2c4e1a79754acd578fa"
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
