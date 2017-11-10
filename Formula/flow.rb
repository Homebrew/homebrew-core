class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  head "https://github.com/facebook/flow.git"

  stable do
    url "https://github.com/facebook/flow/archive/v0.59.0.tar.gz"
    sha256 "732f4d3018bba2d082537190fda68c7cf4d84e24a3a4714361e9949b6ea02961"

    patch do
      url "https://github.com/facebook/flow/commit/ff9c1038c.patch?full_index=1"
      sha256 "e571298199fe0fe557c83f8bd7974438dc4e2587ff0e9c5d32fe3bd7e9685ab0"
    end

    patch do
      url "https://github.com/facebook/flow/commit/12dd84abf.patch?full_index=1"
      sha256 "dfab373d1d7ffe876e27f47757416fe3ef759c2a99ee0d193dd018e6e625e8f8"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c305dc721b437c3e0d6bf78894748e44f694f2ae19909bac5754b86d9d434b30" => :high_sierra
    sha256 "1ee4548967f46773a4683dd4e9db71b524d683d09f0859a4c5c7c6e65505b62f" => :sierra
    sha256 "13d9544cc2abef6b30e8bfe39230063e76dcac11a135f9199560f3ca9dbe6ea1" => :el_capitan
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
