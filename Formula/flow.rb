class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.126.1.tar.gz"
  sha256 "30836754f038f4fff278edadda7153ff4536e0f4cef365fee319dac2d582b8ee"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe87f123df6b040aaa351099cebc696d337a3f2a6d4807b98edce4c8d48ee8ca" => :catalina
    sha256 "85ff81d19ca34654d06934c08db65e495372eb1a91f6e7e8f86b677328cc6131" => :mojave
    sha256 "ee93cd4eb419e9f7293c473a4e7557cccbfc48910b40913fc97a0c1577159ff0" => :high_sierra
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
