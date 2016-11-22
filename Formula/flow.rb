class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.35.0.tar.gz"
  sha256 "c60efe9da95b578705ac61a4666af93a37401d973c37edae1865cd734aa2b95b"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcc4df22ad97211ff8566a12ba04452181d0231790edd9f66617b4cfae03b7a5" => :sierra
    sha256 "e4bf0b9aaf0f77a914f7b25059678d56e9e38ec8bbf5921fc2050f16162a04ff" => :el_capitan
    sha256 "036fd8da08f0ad5ce9988a65432a498a1c3a35f335595fb3c76dcbfa21545b0d" => :yosemite
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
