class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.37.1.tar.gz"
  sha256 "98290b31db94084cadba130d495b19cba76855b52e845bdcdf9f1eb2e3af7978"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6ec38e4a50f4a859fed922a4f320aa1c9fd5692015eaf91bf8414226ba15f2f" => :sierra
    sha256 "0622b95cd3ff29ef3c627ff03580d93d1189a269408744ec96a1b89403a552f4" => :el_capitan
    sha256 "adc2545d21d14f3d85904f2f5b490abe13f549694eb2b87bd7347b5ac929e047" => :yosemite
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
