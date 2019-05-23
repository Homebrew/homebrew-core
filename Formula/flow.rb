class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.99.0.tar.gz"
  sha256 "e2cb9b3f23946e33a72e10aeae14bd4aa3f5d038d49dfd8aede4ab333600101d"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d210df79b8de83e29e1cccd22b6c1009d6c6e217686eac465bceb32bc6170b2d" => :mojave
    sha256 "35965b1e940acc1c736a7aa601ff30e3f6a04932d97048890484ac3bf08c5980" => :high_sierra
    sha256 "5508c74f1e535593c9638a3c105536f74026e1a53c5b89bae0b96e12f15101f4" => :sierra
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
