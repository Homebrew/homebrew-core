class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2024/sqlite-src-3450300.zip"
  version "3.45.3"
  sha256 "ec0c959e42cb5f1804135d0555f8ea32be6ff2048eb181bccd367c8f53f185d1"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6b414e7e7eeb51b437494ea124991bb908a8debe5f6a199dd59cd811fe67154"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f05843e8aac4c5693425f20b0b438771d9d216f9b1e568d5974f0d13363e190"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f6cb3e472eb1a08458f7f33c0be1264b1b3799c56a7dde680387fc7d7ee2cab"
    sha256 cellar: :any_skip_relocation, sonoma:         "8042e7e35a85d5a77539772dd9cf615f3eee541131120b2f90109f031c945952"
    sha256 cellar: :any_skip_relocation, ventura:        "5add371f1be57a4d7e51a54fef72248077d851f1a36fc602f6d4ada44e11f1a3"
    sha256 cellar: :any_skip_relocation, monterey:       "a93663a77a8f0afa0d11e00420b65e38472fa5c9d19a8399a9fdb6d617f05324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e90d3090c0d836ab9b2e2921f492ca216fa2c2dc5e0c5cd70440d269d9ef3e6"
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
