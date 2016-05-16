class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.25.0.tar.gz"
  sha256 "7144ecef267fb629051f6a941652cd6cb26793b9d91213eca0f9ef31a466cffa"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f2ecfe53d734eb178fa824c113eb649a99d97d94c9d946e829aa311b853ad58" => :el_capitan
    sha256 "9997c113e02a5e2596c69345c08f16d66fa7d4833c508bfd18a8a4fcd5482c23" => :yosemite
    sha256 "73db8e20450f1f27000b021fbb60a95826b2aa3405fb6030482051f675ef463e" => :mavericks
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
