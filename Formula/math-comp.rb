class MathComp < Formula
  desc "Mathematical Components for the Coq proof assistant"
  homepage "https://math-comp.github.io/math-comp/"
  url "https://github.com/math-comp/math-comp/archive/mathcomp-1.6.4.tar.gz"
  sha256 "c672a4237f708b5f03f1feed9de37f98ef5c331819047e1f71b5762dcd92b262"
  head "https://github.com/math-comp/math-comp.git"

  option "without-docs", "Don't generate or install documentation"

  depends_on "ocaml"
  depends_on "coq"

  def install
    ENV["COQBIN"] = "#{Formula["coq"].bin}/"
    (buildpath/"mathcomp/Makefile.coq.local").write(<<~EOF)
      COQLIB=#{lib}/coq/
    EOF

    cd "mathcomp" do
      system "make", "MAKEFLAGS=#{ENV["MAKEFLAGS"]}"
      system "make", "install"

      (elisp/"ssreflect").install "ssreflect/pg-ssr.el"
    end

    unless build.without? "docs"
      if build.head?
        system "make", "-C", "htmldoc"
      end

      doc.install Dir["htmldoc/*"]
    end
  end

  test do
    (testpath/"testing.v").write(<<~EOS)
      From mathcomp Require Import ssreflect seq.

      Parameter T: Type.
      Theorem test (s1 s2: seq T): size (s1 ++ s2) = size s1 + size s2.
      Proof. by elim : s1 =>//= x s1 ->. Qed.
    EOS

    system HOMEBREW_PREFIX/"bin/coqc", testpath/"testing.v"
  end
end
