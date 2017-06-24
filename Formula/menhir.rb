class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20170607.tar.gz"
  sha256 "00caa66ed0d1544defda24539f2ca1d37b92120e0575aafc5fcabd8e5364ce61"
  revision 1

  bottle do
    sha256 "2d201c4cceb7b740c458285520e0a0ed2fd6b660e93ab434b53fc4653afff3ed" => :sierra
    sha256 "00de164b1556598a199ab67b94ad239a3c63464796ec90ebd2fbf873845a49e7" => :el_capitan
    sha256 "fdd6ed086c72e4b43375f0618c2102ab40bc9ec0f65214fb72c6273c6f397b07" => :yosemite
  end

  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    system "make", "PREFIX=#{prefix}", "all"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.mly").write <<-EOS.undent
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
    assert File.exist? "test.ml"
    assert File.exist? "test.mli"
  end
end
