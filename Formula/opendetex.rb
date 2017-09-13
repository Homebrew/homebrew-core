class Opendetex < Formula
  desc "Tool to strip TeX or LaTeX commands from documents"
  homepage "https://github.com/pkubowicz/opendetex"
  url "https://github.com/pkubowicz/opendetex/archive/v2.8.2.tar.gz"
  sha256 "7f53cd82fdfdd0e2e359663b1058829f7f2418d1d70f1d8d5b95a805754d5753"

  bottle do
    cellar :any_skip_relocation
    sha256 "39cdc5a7ea7c58d71c091a335e317fedf36cf6151be6202c57cb804ae72f8f4b" => :sierra
    sha256 "cbc742a782838a79605780d5d6df0fc6e59df06ae91a10e4fe7b7fa275984f8c" => :el_capitan
    sha256 "27b3261d9a653795de2ff013ecd424add6ea3684c451d07fee071823c3603a01" => :yosemite
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
