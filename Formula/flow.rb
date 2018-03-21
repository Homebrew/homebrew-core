class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.68.0.tar.gz"
  sha256 "0adc60b022115cb917a5f5a21a96c298fcd8817f2fd92757889d3dab412b7ee6"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "24efec7076cbd854d3bbe9a3ce0578accdd7db03c77d25b9175691beb3a5dd6b" => :high_sierra
    sha256 "70fbc21cd4e013d1fc296e80778b926d6d270694663a136fe78106485c62a3d3" => :sierra
    sha256 "b32a299fdf0ab1016d5cf6b22a1c0541f91f55b5f982532d713912b0995076f4" => :el_capitan
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  # Fix "compilation of ocaml-migrate-parsetree failed"
  # Reported 24 Jul 2017 https://github.com/ocaml/opam/issues/3007
  patch :DATA

  # Fix compilation with OCaml 4.06
  # Upstream commit 16 Mar 2018 "Remove type annotations from let%lwt nodes"
  patch do
    url "https://github.com/facebook/flow/commit/57b1074599.patch?full_index=1"
    sha256 "6a777161985e5f866401b869853be2d39deed298c8c96e3b32765066aa8f097b"
  end

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
