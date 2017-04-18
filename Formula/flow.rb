class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.44.1.tar.gz"
  sha256 "2dbe1c863ea8c594dfde8e2924b32033336f31f039d61ab07e276467195c2028"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "438f3f4f9ba716cf284de96c6b281b539aacd06079afb1309f569845a448488f" => :sierra
    sha256 "2de79b53b4b4ced45cb20bb6571f226f141ade3bee47e290cd2c41a6b7872f7e" => :el_capitan
    sha256 "dc3219feca7362d2a4cd594da510c7e026b0196863fbac82029501b6203e5d35" => :yosemite
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
