class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.40.0.tar.gz"
  sha256 "f09b9191734f7245f906884be57266d24993a5533a68b3ad8ec9992c77ea1230"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ee1fa6fc0ef73e0effc7102679e5e02c1b457433d55bc87807ad690f2f666fe" => :sierra
    sha256 "c23f6d7f19e6c64feb530ee123941f2324aae94f3ae601ff734b42b913b455fa" => :el_capitan
    sha256 "df05178f88aa88956468c2e20d0e0770f5beb80586e94885858bb89d401921d7" => :yosemite
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
