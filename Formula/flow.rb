class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.121.0.tar.gz"
  sha256 "494067d6de027c1a1ba6f13ed13bc4988a71e36d7ff6d12247ea6bd7494989f3"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "243f073e5f03897427cfdf5b478f180a80aac9dcafe60274e42c327c267848cd" => :catalina
    sha256 "9d61952f2deb1b4ceb4af37877e89627c5d64029da0a1c067b560bb0023a5da9" => :mojave
    sha256 "783f36237e52966c7150c5ea6f665fdc623293870029d708dbdb14616bcbdbf9" => :high_sierra
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
