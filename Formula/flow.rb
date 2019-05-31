class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.100.0.tar.gz"
  sha256 "cc4e3883f8b588cb3456901379c3bbd36a104bc56a8cbbc5936350953153ba33"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "93898dfd454b9a1b4db7462e15aec2dfd2d945bf1b6cdd4e47ef960b2606505a" => :mojave
    sha256 "e0bbe45387f6ce185892f054a5c3795650de180b3d69d239d05b3849565c3f0a" => :high_sierra
    sha256 "eeba3f9bb5d2361911418ad9350a14bac0d7f71f407a84cb5fd483796e599185" => :sierra
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
