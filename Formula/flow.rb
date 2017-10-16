class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.57.3.tar.gz"
  sha256 "13371f69c34c33c16f2617cff910b571e5afa9b4703ddfd7b2900dab4d1c8fe0"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "386e6a67eded41486aa2e9e886ac217eb002adf6ed00f762f68d07c3a3950fb2" => :high_sierra
    sha256 "00fec92e55d86a6fbb96ffd57ecd0112e6fcb5b2b70e9af55ac79f58890e2e19" => :sierra
    sha256 "83ae0d58d70bd6bd59ca22ce2a40c0c478c4d3e42d2624eb8de22d68961aa635" => :el_capitan
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  # Fix "compilation of ocaml-migrate-parsetree failed"
  # Reported 24 Jul 2017 https://github.com/ocaml/opam/issues/3007
  patch :DATA

  def install
    system "make", "all-homebrew"

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

__END__
diff --git a/Makefile b/Makefile
index 515e581..8886bf6 100644
--- a/Makefile
+++ b/Makefile
@@ -174,8 +174,8 @@ all-homebrew:
	export OPAMYES="1"; \
	export FLOW_RELEASE="1"; \
	opam init --no-setup && \
-	opam pin add flowtype . && \
-	opam install flowtype --deps-only && \
+	opam pin add -n flowtype . && \
+	opam config exec -- opam install flowtype --deps-only && \
	opam config exec -- make

 clean:
