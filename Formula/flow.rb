class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.24.1.tar.gz"
  sha256 "15865797704ecb8784a5fbc667a467a058e4a0a91f9ea3365da2b2c64409cece"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4fce4ddedff17ce4b5262bee7825cbff6870d5a6b56a7d8df7e00abb53223b1" => :el_capitan
    sha256 "d4ca0d558cd32763a87f4e6332c0a977ca6620a90ce9df42c51e57561325774e" => :yosemite
    sha256 "e0c9858e80334aa4a2f641ea1faee3d571fb5182f3ce094128624e237f5ad296" => :mavericks
  end

  depends_on "ocaml" => :build

  def install
    system "make"
    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<-EOS.undent
      /* @flow */
      var x: string = 123;
    EOS
    expected = /number\nThis type is incompatible with\n.*string\n\nFound 1 error/
    assert_match expected, shell_output("#{bin}/flow check --old-output-format #{testpath}", 2)
  end
end
