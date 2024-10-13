class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2024/sqlite-src-3460100.zip"
  version "3.46.1"
  sha256 "def3fc292eb9ecc444f6c1950e5c79d8462ed5e7b3d605fd6152d145e1d5abb4"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f97b9b726d68d7eacfe42fdd8305f8c1bf2c79c25fe1433345fff50226dc10b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc40a1a967b219db21c06199360a27e377202bcb27b771ce04368e5256751f02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af338ff04a281f92e29e884a9888397d4ccfe5be1ea0384ed038e68b2be0eca5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "440e2df5d8c55841441324c04b3c6bdeac1396b878a62e1673a1bbfbc7741c7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "836b260a0a2961c39311309412ccc2ccc6ede286d53a76453934eebeefc0659f"
    sha256 cellar: :any_skip_relocation, ventura:        "78d2c3224a68d740da650a18fcfe80ae201602dbb5b02fddf54120d18e682cef"
    sha256 cellar: :any_skip_relocation, monterey:       "e0dd71d0117e47591d714fa10d921b40b51c9de6bf42876ead73de6582cd5e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "317ebe4a4b7deaf042fc44ac68b6e26cf90fc1bfc29452d4b929b903372d01be"
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
