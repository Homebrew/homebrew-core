class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20180703.tar.gz"
  sha256 "ab5f16632e81fb67844becde994dbdd6fd875b3a9c799a275af8083f4f2d9b9b"

  bottle do
    sha256 "bffdfb164131cda1c162d68a62ea56d33f97bbe909bd339124ca3ff7386c8396" => :high_sierra
    sha256 "5018812df88d00deff3b20d48ca8264a57fcdb7b162de4a2bbd73ca283d9d919" => :sierra
    sha256 "a2e19a57869a79914f2e2e9da7d0ef5ddb8d67d73aa2d65ff9e26cd1a6d9dc0c" => :el_capitan
  end

  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    system "make", "PREFIX=#{prefix}", "all"
    system "make", "PREFIX=#{prefix}", "install"
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
