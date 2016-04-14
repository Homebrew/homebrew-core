class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.23.0.tar.gz"
  sha256 "f053841511381af3b1bc3d5c682a675ee4cc66fb5dfd4843783e412b31e8464d"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "284f2a919acd53d985bb034c9bc2274df352901aa4720ef5d66faa2d8c069f05" => :el_capitan
    sha256 "82e4cffc5a0a8fce12e80becae527c75f50f5a7b27d5a90ba0ac298ab2d3726d" => :yosemite
    sha256 "82ed2f878afe13631cc2e873bf245363cddf56e273a687228cff0c719335f7c8" => :mavericks
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
