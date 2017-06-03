class HeirloomDoctools < Formula
  desc "troff, nroff, and related utilities"
  homepage "https://n-t-roff.github.io/heirloom/doctools.html"
  url "https://github.com/n-t-roff/heirloom-doctools/releases/download/160308/heirloom-doctools-160308.tar.bz2"
  sha256 "e4aeae0e5303537755c04226c06d98a46aa35913d1a179708fbc368f93731a26"

  conflicts_with "groff"

  patch :DATA

  def install
    args = "PREFIX=#{prefix}", "BINDIR=#{bin}", "LIBDIR=#{lib}", "MANDIR=#{man}"

    system "./configure"
    system "make", *args
    system "make", "install", *args
  end

  test do
    system "#{bin}/troff", "-V"
  end
end

__END__
diff --git a/eqn/eqn.d/Makefile.mk b/eqn/eqn.d/Makefile.mk
index d6e573c..020c6fe 100644
--- a/eqn/eqn.d/Makefile.mk
+++ b/eqn/eqn.d/Makefile.mk
@@ -34,23 +34,23 @@ clean:
 mrproper: clean

 diacrit.o: ../diacrit.c ../e.h y.tab.h
-eqnbox.o: ../eqnbox.c ../e.h
-font.o: ../font.c ../e.h
-fromto.o: ../fromto.c ../e.h
+eqnbox.o: ../eqnbox.c ../e.h y.tab.h
+font.o: ../font.c ../e.h y.tab.h
+fromto.o: ../fromto.c ../e.h y.tab.h
 funny.o: ../funny.c ../e.h y.tab.h
 glob.o: ../glob.c ../e.h
 integral.o: ../integral.c ../e.h y.tab.h
 io.o: ../io.c ../e.h
 lex.o: ../lex.c ../e.h y.tab.h
 lookup.o: ../lookup.c ../e.h y.tab.h
-mark.o: ../mark.c ../e.h
-matrix.o: ../matrix.c ../e.h
-move.o: ../move.c ../e.h y.tab.h
-over.o: ../over.c ../e.h
-paren.o: ../paren.c ../e.h
-pile.o: ../pile.c ../e.h
-shift.o: ../shift.c ../e.h y.tab.h
-size.o: ../size.c ../e.h
-sqrt.o: ../sqrt.c ../e.h
+mark.o: ../mark.c ../e.h y.tab.h
+matrix.o: ../matrix.c ../e.h y.tab.h
+move.o: ../move.c ../e.h y.tab.h
+over.o: ../over.c ../e.h y.tab.h
+paren.o: ../paren.c ../e.h y.tab.h
+pile.o: ../pile.c ../e.h y.tab.h
+shift.o: ../shift.c ../e.h y.tab.h
+size.o: ../size.c ../e.h y.tab.h
+sqrt.o: ../sqrt.c ../e.h y.tab.h
 text.o: ../text.c ../e.h y.tab.h
 e.o: e.c ../e.h
diff --git a/eqn/neqn.d/Makefile.mk b/eqn/neqn.d/Makefile.mk
index bb924fc..33b6649 100644
--- a/eqn/neqn.d/Makefile.mk
+++ b/eqn/neqn.d/Makefile.mk
@@ -31,23 +31,23 @@ clean:
 mrproper: clean
 
 diacrit.o: ../diacrit.c ../e.h y.tab.h
-eqnbox.o: ../eqnbox.c ../e.h
-font.o: ../font.c ../e.h
-fromto.o: ../fromto.c ../e.h
+eqnbox.o: ../eqnbox.c ../e.h y.tab.h
+font.o: ../font.c ../e.h y.tab.h
+fromto.o: ../fromto.c ../e.h y.tab.h
 funny.o: ../funny.c ../e.h y.tab.h
 glob.o: ../glob.c ../e.h
 integral.o: ../integral.c ../e.h y.tab.h
 io.o: ../io.c ../e.h
 lex.o: ../lex.c ../e.h y.tab.h
 lookup.o: ../lookup.c ../e.h y.tab.h
-mark.o: ../mark.c ../e.h
-matrix.o: ../matrix.c ../e.h
-move.o: ../move.c ../e.h y.tab.h
-over.o: ../over.c ../e.h
-paren.o: ../paren.c ../e.h
-pile.o: ../pile.c ../e.h
-shift.o: ../shift.c ../e.h y.tab.h
-size.o: ../size.c ../e.h
-sqrt.o: ../sqrt.c ../e.h
+mark.o: ../mark.c ../e.h y.tab.h
+matrix.o: ../matrix.c ../e.h y.tab.h
+move.o: ../move.c ../e.h y.tab.h
+over.o: ../over.c ../e.h y.tab.h
+paren.o: ../paren.c ../e.h y.tab.h
+pile.o: ../pile.c ../e.h y.tab.h
+shift.o: ../shift.c ../e.h y.tab.h
+size.o: ../size.c ../e.h y.tab.h
+sqrt.o: ../sqrt.c ../e.h y.tab.h
 text.o: ../text.c ../e.h y.tab.h
 e.o: e.c ../e.h

