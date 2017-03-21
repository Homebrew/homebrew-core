class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20170101.tar.gz"
  sha256 "99696f365511e0440c18d295b7073a13886c5b594e1875f5967ad897a2216a46"

  bottle do
    sha256 "60f84b925e70bf005f84a9441c2134c2ffe48980d6c44883ce84e154b0c46d9a" => :sierra
    sha256 "016653898fd56dfd858cfd227dbb5b9678c4e9daf4b10c0555b7042ed8d93ed5" => :el_capitan
    sha256 "bde51805532613d051e17044779da9e2707c29aa8ffe94c62a83a862a81e1f26" => :yosemite
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
