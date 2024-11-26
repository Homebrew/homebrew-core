class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2024/sqlite-src-3470100.zip"
  version "3.47.1"
  sha256 "572457f02b03fea226a6cde5aafd55a0a6737786bcb29e3b85bfb21918b52ce7"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "081792d353b3909003a458d4797813b29222de2ff2f26e70635afbc848010b1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a775ee486092bf3f5a8b7afc0a311b6d9b5a0d96a7ca76b5ccf0541cdaf79c8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "922f3ced2491bdb33b67e1c4434270f9f367625de170d358c3abe322c5bcb89d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d660f36fd22df9e54ab8be721fee8302a49d045e659497ff9f22e509d710202"
    sha256 cellar: :any_skip_relocation, ventura:       "dc7f239662a9872e360a6ae010d83d07c669d1415e55c988a663bd51ecffce19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9bbce166d923eeae00f227b4480bb383782a156a4f1a54499757a4c05f84824"
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
