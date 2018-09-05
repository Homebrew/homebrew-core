class Opendetex < Formula
  desc "Tool to strip TeX or LaTeX commands from documents"
  homepage "https://github.com/pkubowicz/opendetex"
  url "https://github.com/pkubowicz/opendetex/archive/v2.8.4.tar.gz"
  sha256 "d1ca2ba332d0b948b3316052476d3699a7378ab83505fe906a2ba80828778f84"

  bottle do
    cellar :any_skip_relocation
    sha256 "995070391cee23f402d6e067985230d467e48b5a20b5122e05474bec73cfeb24" => :mojave
    sha256 "c668bd3fd940b6f27ce4162b5625ff28e45df24e34f7f66b6a2158546a47e6d9" => :high_sierra
    sha256 "4ce5d750a06de0c96682042e88aea55707e5c0b28cbea66396ec1020df130420" => :sierra
    sha256 "79e56e9e50f90d6b534f29c556a648743ee10ab494d5f7cd049031eb4833f122" => :el_capitan
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
