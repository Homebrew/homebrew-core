class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.53.1.tar.gz"
  sha256 "96c3a3af7ce648184401a8738800ec34fac6625fc97c547671088f4a00604a7a"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eea2889b33068478835249fd9c1b6dfc1a77270b584d041dbc7d28838aa5c5cc" => :sierra
    sha256 "b79361ee4b25aa5e20771d71b6ba8a5c23a4befa9c88c85e5ae6fd4a2f4d6e98" => :el_capitan
    sha256 "ef30f638a799ef94e29fbb590c71970f49e3673a162ebcf1580f1cfa84759588" => :yosemite
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
