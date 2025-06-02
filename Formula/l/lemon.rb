class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2025/sqlite-src-3500000.zip"
  version "3.50.0"
  sha256 "af673f28f69b572b49bb1558c4f191fd66e31acb949468ad2b01b2b6ed8043a2"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5ee461cd900642be555bb4c482b6bf362a22bf4a8fc79c31c28ebbd13e44666"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c429609c354c358de698b47d5988b3593cfae29a3f7cf566be3465d43f6f6d95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "626e8c32d57cb2e0d52d90c6ce9165a64fbc14ba37e949de84cb2a3266fefea4"
    sha256 cellar: :any_skip_relocation, sequoia:       "8e4df66457c8a7fa2e11adf507c97830ceb6b1b7d9e3627155debf73d2ee6b5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcfa27ee8cfbbdd4e2ceefd6c4572d503576a5c11f7f6f2997aec344436121ec"
    sha256 cellar: :any_skip_relocation, ventura:       "9cca0e0341ee329d091de3ef81986252738863195011794aaeb260eccb9c405b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8780dbde3a5c461afe09194eee02970067ac9c48796f46897db87dd85801ff28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fc24ba909bfeb0b3bfbae574d513af4dd026380b508f6773b0929f00b2e9b56"
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
