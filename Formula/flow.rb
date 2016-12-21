class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.37.3.tar.gz"
  sha256 "4913a56b5498bb458f3d0e70328513b5c3ec7c2a63f173c24fbd0814935c3844"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c90488414573a5f97a9db020473bcbd5e3e5b093cb386e21dfd224ac08e09317" => :sierra
    sha256 "d327677da4d09b972db50b6fd3d10050a6e5940438839bde8ddcec99747dea4a" => :el_capitan
    sha256 "51ee9de57a15197c1c6a8b2a333d2d9ba5bf347924d1f4ec4e9e8fc239a7501e" => :yosemite
  end

  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build

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
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
