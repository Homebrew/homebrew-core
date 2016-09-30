class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "http://cristal.inria.fr/~fpottier/menhir/menhir-20160526.tar.gz"
  sha256 "dac27e31b360331cbac92d6cafb917e52058cb5bb8301337c3c626a161c7dec4"

  bottle do
    sha256 "7a04b59dd923fcbf6c4e78f7187825f546c27269ce273ca3742c46ac1ad12c49" => :sierra
    sha256 "0c38fe3f3442c0c51e5160ef56e5b593a4fe7a7e4e72039c67090276e805f10d" => :el_capitan
    sha256 "6c2b4758235e372c85acaa6e92d4673a78c243978691f969c32cec20099838d2" => :yosemite
    sha256 "e7bc0427e337e519750c89410f235f05198ca8996cc40bbefc5f46e64fc71355" => :mavericks
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
