class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20160504.tar.gz"
  sha256 "5fcd7cd38eef7ec78eee12cfaa9d22cbec6ba85f8d42e45b86215a89a496b20d"

  bottle do
    sha256 "76ad73cc2d4f0b2a7729b5057d2a27c3e10e1aedfd95779af435419bab9062fa" => :el_capitan
    sha256 "8ec208a2b6f43b83aee96e2218c865e97315d7a01023aef694980e5a887579d5" => :yosemite
    sha256 "822dd6fcc7ea291329b7f20e2894013929f0e64230ce47e6e36dc13ee70e8dbb" => :mavericks
  end

  depends_on "ocaml"
  depends_on "ocamlbuild"

  # Workaround parallelized build failure by separating all steps
  # Submitted to menhir-list@yquem.inria.fr on 24th Feb 2016.
  patch :DATA

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

__END__
diff --git a/Makefile b/Makefile
index f426f5d..54f397e 100644
--- a/Makefile
+++ b/Makefile
@@ -116,7 +116,11 @@ all:
	  echo "let ocamlfind = false" >> src/installation.ml ; \
	fi
 # Compile the library modules and the Menhir executable.
-	@ $(MAKE) -C src library bootstrap
+	@ $(MAKE) -C src library
+	@ $(MAKE) -C src .versioncheck
+	@ $(MAKE) -C src stage1
+	@ $(MAKE) -C src stage2
+	@ $(MAKE) -C src stage3
 # The source file menhirLib.ml is created by concatenating all of the source
 # files that make up MenhirLib. This file is not needed to compile Menhir or
 # MenhirLib. It is installed at the same time as MenhirLib and is copied by
