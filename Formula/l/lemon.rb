class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2026/sqlite-src-3530100.zip"
  version "3.53.1"
  sha256 "1b2b5755d9064c4d5d1b0bf5307b48b089963e291c40cc7351318aa1b61c460e"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8aaeb2fa432d425571bb9096f1327657ca0c7fd73b7eafc3f2b24453440a0784"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3eea44b0d549a28539565843f7b20d4fd420fe521fb9ab53015e40e623e5e005"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a0480b9f1438aad9bba2917502d53242a2e98199531ebe4f823565e038857d7"
    sha256 cellar: :any_skip_relocation, tahoe:         "60c7f0fe0caed8a3307d0a24f302e8d75774561a412eb443183cffe9e2d13d26"
    sha256 cellar: :any_skip_relocation, sequoia:       "0d7cacc3faa9b644e69739da343e37d257a004a244401b59f9f73a605a9cb66e"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa3173ea0b4b36f3a52ef14a7f87c0a8e3c1a3ad848787ec2638071bcb6614f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b3eadaa296e3b99402567f3895176530794340051f323f3c9375e2596921f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d31fa9987363e8988ced979a405bbb54a2370a94747ec5be2a96925b35f30a32"
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
