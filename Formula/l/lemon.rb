class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2024/sqlite-src-3470000.zip"
  version "3.47.0"
  sha256 "f59c349bedb470203586a6b6d10adb35f2afefa49f91e55a672a36a09a8fedf7"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce26c4b8d6eee5f8628e0d7b0fd60063ccdc0c338d8370c358a80f87f11428e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2a3f55a435bf9f9ed8a09de4085d0b9551b86b5cd3b9c455fb70805a88e3a78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4abba4edb917cb72557e23f4d0d89656df4e04cd85fe44a13ee6e0ae19b51c1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "76466d7ad2d960adc276aee78df66ab6e284c9723d1a5a391a38d32e10a6a130"
    sha256 cellar: :any_skip_relocation, ventura:       "3bfdfc81544543440e8186ffb170e5a77ea0f6bf6b0542cbba1b31272d8a4690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb598b688ebc24959b03b526f87d79f784f74396e59056bbd9a78df325a9f7a6"
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
