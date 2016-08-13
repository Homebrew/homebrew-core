class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.30.0.tar.gz"
  sha256 "e28d84c0e43c53d46d3b0d1fcf6563f7579d8958d6b0d4b71cb6cb7e5941b4ca"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "12ea00619c07bc8b75bc941589a434f031f2e5b0d6173e8434ee175865d46808" => :el_capitan
    sha256 "fb58725c821c2ee6e30058fa216aa2b14d6e44c55e08bd0d79024037da00d9eb" => :yosemite
    sha256 "a3c5018b8144b5075944a40dabcdffdb9a61e6923fee5e440bd5b48047b482dc" => :mavericks
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
