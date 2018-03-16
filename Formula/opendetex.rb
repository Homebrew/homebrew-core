class Opendetex < Formula
  desc "Tool to strip TeX or LaTeX commands from documents"
  homepage "https://github.com/pkubowicz/opendetex"
  url "https://github.com/pkubowicz/opendetex/archive/v2.8.3.tar.gz"
  sha256 "1f8a967ff7445ec498586e045def35474bf2cbc2b5669043fffbc569deb84c10"

  bottle do
    cellar :any_skip_relocation
    sha256 "39f296a67d7bb776673c7bf967612c0978f3d9a9bae6f96604e8ac1e18c76cbf" => :high_sierra
    sha256 "a5e9edb249ef5d97a72afaa586effbdd4ef7b48ff4b1fb0d0078615849bbea27" => :sierra
    sha256 "4cc67ed6010d4b4ac0c0df288af9fe66e55ab7446a297b1fa65bf5e78c7d769b" => :el_capitan
  end

  patch :DATA

  def install
    system "make"
    bin.install "detex"
    bin.install "delatex"
    man1.install "detex.1l" => "detex.1"
  end
end

__END__
diff --git a/detex.1l b/detex.1l
index a70c813..7033b44 100644
--- a/detex.1l
+++ b/detex.1l
@@ -1,4 +1,4 @@
-.TH DETEX 1L "12 August 1993" "Purdue University"
+.TH DETEX 1 "12 August 1993" "Purdue University"
 .SH NAME
 detex \- a filter to strip \fITeX\fP commands from a .tex file.
 .SH SYNOPSIS
@@ -103,7 +103,7 @@ The old functionality can be essentially duplicated by using the
 .B \-s
 option.
 .SH SEE ALSO
-tex(1L)
+tex(1)
 .SH DIAGNOSTICS
 Nesting of \\input is allowed but the number of opened files must not
 exceed the system's limit on the number of simultaneously opened files.
