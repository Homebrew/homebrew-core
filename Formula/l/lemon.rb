class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2026/sqlite-src-3530200.zip"
  version "3.53.2"
  sha256 "cafff764c03f6d720968f746e2f47a986bbf12bf4c18904f1eb131c0b0b592d3"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5ef919560f65eeaba29621cf4cd859bac25ee0d1da272358c16b342dc8233c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7ce2bb458e00d373a6652c11e36bd0447fdf1652d4f376f561588fd1768fb83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a83fff92bdff4af9c895742ec80369383b8f14f1230401b0d6c2338d8601d30c"
    sha256 cellar: :any_skip_relocation, tahoe:         "0435a248149fd0e94f3f80744770c9fd7dfb9359bf2559d453ce075c07495d51"
    sha256 cellar: :any_skip_relocation, sequoia:       "ed4b87abf4c3b1a0e70d75c48672cfccbb1c2268549492f0cdc116a4fab9cc53"
    sha256 cellar: :any_skip_relocation, sonoma:        "9592c623334ffd7747dd54f6d5ca7b816f00c5be7907004aa92ed7bc0a1069d1"
    sha256 cellar: :any,                 arm64_linux:   "d7822332b870727f1401f837c762e1c8450c4ea885810f0f7435d4bea6d97538"
    sha256 cellar: :any,                 x86_64_linux:  "e550fe884358baa7ad36b71e05ebb2f620dd124a0e486419773c0f099e87aa5d"
  end

  # Submitted the patch via email to the upstream
  patch :DATA

  def install
    pkgshare.install "tool/lempar.c"

    # patch the parser generator to look for the 'lempar.c' template file where we've installed it
    inreplace "tool/lemon.c", "lempar.c", "#{pkgshare}/lempar.c"

    system ENV.cc, "-o", "lemon", "tool/lemon.c"
    bin.install "lemon"

    pkgshare.install "test/lemon-test01.y"
    doc.install "doc/lemon.html"
  end

  test do
    system bin/"lemon", "-d#{testpath}", "#{pkgshare}/lemon-test01.y"
    system ENV.cc, "lemon-test01.c"
    assert_match "tests pass", shell_output("./a.out")
  end
end

__END__
diff --git a/test/lemon-test01.y b/test/lemon-test01.y
index 0fd514f..67a3752 100644
--- a/test/lemon-test01.y
+++ b/test/lemon-test01.y
@@ -54,8 +54,8 @@ all ::=  error B.
     Parse(&xp, 0, 0);
     ParseFinalize(&xp);
     testCase(200, 1, nSyntaxError);
-    testCase(210, 1, nAccept);
-    testCase(220, 0, nFailure);
+    testCase(210, 0, nAccept);
+    testCase(220, 3, nFailure);
     nSyntaxError = nAccept = nFailure = 0;
     ParseInit(&xp);
     Parse(&xp, TK_A, 0);
@@ -64,7 +64,7 @@ all ::=  error B.
     ParseFinalize(&xp);
     testCase(200, 1, nSyntaxError);
     testCase(210, 0, nAccept);
-    testCase(220, 0, nFailure);
+    testCase(220, 2, nFailure);
     if( nErr==0 ){
       printf("%d tests pass\n", nTest);
     }else{
