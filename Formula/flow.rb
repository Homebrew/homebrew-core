class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.188.2.tar.gz"
  sha256 "e91f2941f97f87e418320e26478a839d166d78f76199e50455abfa2154f6b2b5"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c50b253501730dc0c4f2f7563797b9a8a3bab20e4e4a17d8f8d2611580bf2bcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "007370c2769cb9364962c5f1d531f4c8781c8b451446229231dec899ddda0d31"
    sha256 cellar: :any_skip_relocation, monterey:       "4b18e1364d9826cd2b1a8939cad2baec39d0b775ed86bf0cfafd58501f173754"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6a288bdea994d68f50ad143d2578fd10e6ec3acf8e15674254ef14c7bb83add"
    sha256 cellar: :any_skip_relocation, catalina:       "d7f16203873892b35761d48c33d67e030a81fcb0fd27a4ce0891e803624b3680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c97ae54396a5dd37e35f94ddef344aaf32a031178513394cfdb4a61c73feff1a"
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
