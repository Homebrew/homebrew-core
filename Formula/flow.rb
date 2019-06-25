class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.102.0.tar.gz"
  sha256 "752912317d263991c11b7d195e50260ac06685a4e9399fdc7c34074d4b0588b1"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a17a329a03d3d4b1d7bf3a8fb933c1b80126257a30d2c0a2595aebe6980a68d5" => :mojave
    sha256 "398600427611a8bd465540ec3260afed07e9635b30043a21129fb20871130171" => :high_sierra
    sha256 "d8fd3162eae1def6874130b0147faec8102c118ffd5c90ff07bcc38786af7b6f" => :sierra
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

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
