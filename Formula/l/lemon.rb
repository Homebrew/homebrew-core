class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://sqlite.org/2025/sqlite-src-3510000.zip"
  version "3.51.0"
  sha256 "5330719b8b80bf563991ff7a373052943f5357aae76cd1f3367eab845d3a75b7"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a43d8d0bb25ed0800b9cc98560c79e38063b3ede4bcbf757280e4b12a4396d84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf58951dd1e0db067fd6825545f9638c44e628b5f4e31f1bbc28789d240caa94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5ecb2b34578f838ce27f8ef3108016b991aef2efed328f8407122f755934d90"
    sha256 cellar: :any_skip_relocation, tahoe:         "d19dc6d19dedae92c35686deb90a18f3299a5195d865cc1a9527d9c49dedc84e"
    sha256 cellar: :any_skip_relocation, sequoia:       "a049aa9bfb2a8591eacf3b6f2dc30d86e63def9d8a5414febb871be1e7fddf07"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed9aaaddf7b9fbed3a7817405b2ce18b81aba4b98c52b8bfcc2d7c894dad6e8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64276cb815afa0dc00d2f44ef20aa881bbd93fb2154e7d8958a095cf31664094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68678cb6aade79637b1ec947b1511d2691cbb7420e09b99205f5acb269565800"
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
