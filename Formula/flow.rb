class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.33.0.tar.gz"
  sha256 "c5d19fc5b8f425be24bf6d62eeff2b8a7fdb8bf8138a46ffd8864491bd4f754b"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3d013ab0d8127c296006c0dffc366d934af6fc8e3021164e116737ecc4bebaa" => :sierra
    sha256 "000a6c34aa5dd71320c94554ded1d82d4e9996bfa04f6955ab5d28d22aada1eb" => :el_capitan
    sha256 "7e31bdb5901f5a83bcb43ef58f43e1db226c2af04641d3c618601df024a646ba" => :yosemite
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
