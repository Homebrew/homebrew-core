class Opendetex < Formula
  desc "Tool to strip TeX or LaTeX commands from documents"
  homepage "https://code.google.com/archive/p/opendetex/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/opendetex/opendetex-2.8.1.tar.bz2"
  sha256 "8a47e4c7052672dfe5e0a4214dd5db42ac4322eb382efe6fd1fb271b409d051e"

  bottle do
    cellar :any_skip_relocation
    sha256 "b189aeead03a4ab3b98007b793e869f84e8266acf562492f4bdbedb8d2966ca0" => :sierra
    sha256 "279c7801888a46fdfea578b6a40874aa61b775b87f0ea6a92e738f57f0a21f27" => :el_capitan
    sha256 "25c4ce538ac084436d393a29e9cd24a5d0da8ccab59e25bc76b65c0852563bd3" => :yosemite
    sha256 "a640db332cfcb428d1994321aa0da127ec48eab01fc98b89509033eb6a189b89" => :mavericks
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
