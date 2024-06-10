class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20231231/menhir-20231231.tar.bz2"
  sha256 "fb76a37b84e28acd3ecf58efea3abc8c7a9a70987a44915837e81093a7853d3a"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "51bd3947698d7b10bb3c564ac1af6253939cc2c92a213a987eab78b69eca413e"
    sha256 cellar: :any,                 arm64_ventura:  "ecc727bfc088943865ce50c8a119f22cc119cb0bb40475c3b335ec0106ccb4c3"
    sha256 cellar: :any,                 arm64_monterey: "13297c3d65c7163ed6435b61b976bbb382627c1f0287d4c451e96504a1482666"
    sha256 cellar: :any,                 sonoma:         "cd93d31e5b19eeaa76015c1fe532b47bfd9da10751b4e22b39868e5799bf1ef2"
    sha256 cellar: :any,                 ventura:        "53593f93829e9fa15b9fa2454941ddc5a3b9bb51b9d1715ad37c39102c7aee2c"
    sha256 cellar: :any,                 monterey:       "b7c47233eb83cc4fdef9408f13d72d43f38d098526be8412dba83b3fde002729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0cc957c64dc08d73d4d141746d7d2707db4d7c405b2835060dd8f5c827c023b"
  end

  depends_on "dune" => :build
  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  # Allow to compile with OCaml >= 5.2.0
  # Shall be removed once the first new version of menhir after 20231231 is released.
  # https://gitlab.inria.fr/fpottier/menhir/-/commit/9b49658fc64736511ec41a06bb474afbf3dc6690
  patch :DATA

  def install
    system "dune", "build", "@install"
    system "dune", "install", "--prefix=#{prefix}", "--mandir=#{man}"
  end

  test do
    (testpath/"test.mly").write <<~EOS
      %token PLUS TIMES EOF
      %left PLUS
      %left TIMES
      %token<int> INT
      %start<int> prog
      %%

      prog: x=exp EOF { x }

      exp: x = INT { x }
      |    lhs = exp; op = op; rhs = exp  { op lhs rhs }

      %inline op: PLUS { fun x y -> x + y }
                | TIMES { fun x y -> x * y }
    EOS

    system "#{bin}/menhir", "--dump", "--explain", "--infer", "test.mly"
    assert_predicate testpath/"test.ml", :exist?
    assert_predicate testpath/"test.mli", :exist?
  end
end

__END__
diff --git a/sdk/cmly_api.ml b/sdk/cmly_api.ml
index acbb8714..88c93951 100644
--- a/sdk/cmly_api.ml
+++ b/sdk/cmly_api.ml
@@ -146,7 +146,7 @@ module type GRAMMAR = sig
     val default_reduction : t -> production option
 
     val reductions   : t -> (terminal * production list) list
-    [@@@ocaml.deprecated "Please use [get_reductions]"]
+    [@@ocaml.deprecated "Please use [get_reductions]"]
   end
 
   module Print : sig
