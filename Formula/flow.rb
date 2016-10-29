class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.34.0.tar.gz"
  sha256 "d09e99663225dbee2c92fa51ee563d45ff2c2bb70c4738dfc44233b70399f94f"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4799fddfd7c6b3440b515ec376f8aa6a342b7892382c8a3498a179b97fd38c7f" => :sierra
    sha256 "f867debd6dac21decf310eccb082b416f23f5574f280192b77c07a9b1b862ed7" => :el_capitan
    sha256 "f4ca564ae3f241caf9ab3abe725a3d560767f2ba430d7317ae15a164e4f8ab00" => :yosemite
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
    expected = /number\nThis type is incompatible with\n.*string\n\nFound 1 error/
    assert_match expected, shell_output("#{bin}/flow check --old-output-format #{testpath}", 2)
  end
end
