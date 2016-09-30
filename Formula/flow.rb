class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.33.0.tar.gz"
  sha256 "c5d19fc5b8f425be24bf6d62eeff2b8a7fdb8bf8138a46ffd8864491bd4f754b"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2cf3b3b63415bec1e63dbf578c675ded9a3c9042f78dba61b30a065aa5553a9f" => :sierra
    sha256 "1b84691a232c771cdde97fbdb2cdf7b2fce3aa4d9e341b1f7169d0424614b6ba" => :el_capitan
    sha256 "b7210405ec81f9a68a0eba2b1333161f03be930125464a832becab1185afb7f5" => :yosemite
    sha256 "64e79ab56f20438efc7a9c21c2555cb7abb3086ef74fb5f6f8b075921447847b" => :mavericks
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
