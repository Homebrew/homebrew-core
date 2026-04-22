class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://sqlite.org/2026/sqlite-src-3530000.zip"
  version "3.53.0"
  sha256 "fbc30cdbfcfa42c78fe7bddd3fd37ab8995369a31d39097a5d0633296c0b6e65"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45cdb02d7658c7f84c860fc7cde813cd39226a5b2d0709278b7ecb13afdb0526"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7c9fe0b799e4877ab4fba0972ed8d9be061f1485fe006e12efc379ce30a8753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2be5d897a1a30b4f29f39ffe125e7389a0eae464d31e57a7bbd90eaa4950798a"
    sha256 cellar: :any_skip_relocation, tahoe:         "623cda095c8a27d1543a8e8f91673b627b071574481753cc9d9ff1bd6e67e936"
    sha256 cellar: :any_skip_relocation, sequoia:       "784a0ed7a1d388c599cf13bd4fa3216e7d7738fe33f7d58114b077bf4fea38c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "012c3b108476a50ad3d1c74e2c24588841b64eefa063ae969cb5ca8b0b78cdac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aac16aef580240d3fc215a54dc26a27de689483de6686280d4344390e168c1d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "352442ce0d797edd5dc659162145b27b610a20af10fa458479528e11a0755921"
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
