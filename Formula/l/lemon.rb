class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2023/sqlite-src-3430000.zip"
  version "3.43.0"
  sha256 "976c31a5a49957a7a8b11ab0407af06b1923d01b76413c9cf1c9f7fc61a3501c"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d7cdbdddd60700833c0f86a6c21bef61320940fb1f32744cfa0a21ec5d8a355"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "193ad9d4bc46bae7568f15067d2f47b61c4b9296f345f3aa6d4dc1663eacd383"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0b259f85ab7135daf8c38a4459dfff0856d58723b012ae2dbb871382bbaadc9"
    sha256 cellar: :any_skip_relocation, ventura:        "04721093d0ca70927c48c88591d7f444e76de8457b82f122b0827cc127f6303a"
    sha256 cellar: :any_skip_relocation, monterey:       "e6f36d966ba30da4cf4faf7e2f427f7ddbad85e731af58b4c11b2a4d02912619"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fabd9462f3922a2c20785826c0373be8e78d5c7e41c3885bfca65ea1022dc54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3b40f5118e2828b29367856bdf3a1d95ef98ea10309946b3e6196eda68b22f1"
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
    system "#{bin}/lemon", "-d#{testpath}", "#{pkgshare}/lemon-test01.y"
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
