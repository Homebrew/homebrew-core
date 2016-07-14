class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.29.0.tar.gz"
  sha256 "146289061d01b962519804622a6f400a72f48ff5b813c9b9c097a6bdff9237be"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "10e3be48ead5c466b05dbcfd18127bd96bfab07d5db911de1c4b76a3d059dfa7" => :el_capitan
    sha256 "0ad49c02f0b0d31ff8cb15283cb6d573d1cc253e5c6d73ba58012899edac9a37" => :yosemite
    sha256 "d5cc29bbd16a10eff51a7ff219c12911149e394ac94bb7f4dc37068b0338808a" => :mavericks
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
