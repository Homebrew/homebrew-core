class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.106.2.tar.gz"
  sha256 "f70a1874b7bdbcafea8e5828b21ebfe64e53fd5c4470ea8b42d99d1eb942f44d"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9db80cbd9fae62994ed91e2fcf040f4dc3635f947d464f2760fa267b4b898417" => :mojave
    sha256 "0004cc1704adf958559a05c652e6f6c2b0285df135190fc39ab9c12f6e791112" => :high_sierra
    sha256 "f1323d852912bf1b758ab223f0d8048273c88f092ccfc2f76e12a1bea3726de7" => :sierra
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
