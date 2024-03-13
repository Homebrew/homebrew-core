class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2024/sqlite-src-3450200.zip"
  version "3.45.2"
  sha256 "4a45a3577cc8af683c4bd4c6e81a7c782c5b7d5daa06175ea2cb971ca71691b1"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "beda42023d227c38a98bce2d924be9d5c216b40fd6fc90524004cd988962349d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e90a285ef4c04ad584f62d29b29a83b9d87336026b89e587ab90fb4af409f4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de0392a56ebe63c4cd8f8202311ea197a7034647c7eac1abef6da01a07c8dc10"
    sha256 cellar: :any_skip_relocation, sonoma:         "59277362620b8f9d55482c2be3dd3a5850e37c438a67c6485944f0ede9858ed2"
    sha256 cellar: :any_skip_relocation, ventura:        "2a89242bd10a7ff02433e224009cba5a261309212c226aa8623d97eede04b400"
    sha256 cellar: :any_skip_relocation, monterey:       "dbb1482ffd611fee05a958c8ac00d21028668b086182dff4aaead424c77853a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1769e87592a6ea3fbdbdd7746a68f579894ba75b29755d38e7bdc2867fa7a3a"
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
