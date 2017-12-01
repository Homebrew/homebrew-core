class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.60.0.tar.gz"
  sha256 "da2ff9d452530f850608bd704dd78822aab1864f02e7779e124a47e2ebbc23fe"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "37c5e6c1f8788d4be492f429cecd0cf2f6b290fb0d2a6bd4a579949c41e46082" => :high_sierra
    sha256 "7492dee02b926228d5649c9a7da7e717f3f81ef9486dbac96ecf013bcf9fac23" => :sierra
    sha256 "dfb23b89e259b3daefc1b1c3fba57e859a8be3ebf569a5e9ff99a4a080aaf389" => :el_capitan
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
    (testpath/"test.js").write <<~EOS
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
