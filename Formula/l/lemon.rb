class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2026/sqlite-src-3530300.zip"
  version "3.53.3"
  sha256 "bb80bf8a3bffc19241ce8aba5a4bc74e9c3980013cb0b5f0f0976a99516942af"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c4f11b4b69667d76ff88e584d203cdbc06e0e76b55482a53814392b0625d3d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c78bdded10cf1773cd9cefb44ddacf73076c80c846551127af0b93d2feb51f53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdaa378c710e60da081096346f7f805a204d40daa6458ef22b94cc5737a0d2ef"
    sha256 cellar: :any_skip_relocation, tahoe:         "78abc50182a455103935b9856bf2cc59a617d9482a1aa86af913fdd7deaf1e70"
    sha256 cellar: :any_skip_relocation, sequoia:       "033e6ca1f757a183b26b97f9f1e0759c313293a499f695d13b7e8bcac2cd1ba7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1ed400d8f29b01b987f9df6b95d4020068794722591bb668cf5392b1df7fc3b"
    sha256 cellar: :any,                 arm64_linux:   "6b85ff8469a8cc39e0077e2c05929cbea7b23087fe1e0a69080550a725cd6f1e"
    sha256 cellar: :any,                 x86_64_linux:  "eb3b76ec92a5f0b4e11b7d2781d5e8bf54c7f096b64655723d24182cf5fc20ad"
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
