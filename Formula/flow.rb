class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.118.0.tar.gz"
  sha256 "d9eaadc7c92e40f1eb9c74458c7e138fd32832c5cef9a5f30ebba22eaa8cc381"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "daa2866b0f42b47b7bd08c8d0b619bd3201199f66c685f342ac8fd740a54aa6c" => :catalina
    sha256 "850aec6fe8109a49f30cbfd1b44fdb573ed6d8e54453fa16676d9fee2aa553ca" => :mojave
    sha256 "8b766039dd25a910df4de62252b24fab6b92e35c686909f61954af75b06a848e" => :high_sierra
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
