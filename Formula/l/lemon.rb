class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2025/sqlite-src-3500200.zip"
  version "3.50.2"
  sha256 "091eeec3ae2ccb91aac21d0e9a4a58944fb2cb112fa67bffc3e08c2eca2d85c8"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "414172887c97ed5d838646da4bbb3260a2eedfab1faa47daa1050c62403757ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eff9119cae6d6e265a943170a7de9c8079f1170c8ef70da614ab7cd4ccee2749"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "570499c4fa80a48f3b191996f3881e4538adbc17c88473ae681db2ea4d9ad1f1"
    sha256 cellar: :any_skip_relocation, sequoia:       "1b3d3f0fed1042c521a78573f2fda4ca285434401c4923e1a1d3b0fb13524fbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1d89c33f856ea25481dd3f493fea1314767157c1bc7bcc0c97aab4c5147992f"
    sha256 cellar: :any_skip_relocation, ventura:       "df307bfb982598942757c1eda0805b63b9d8e6d76833a173a10ad1c742b16f4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f73346819b72be7b12566e50ccb145cf265fe6ce494b735f469fe282ff578ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b73cc3df9d3f51168eb1ddb05d79b2aadac9d6e8bfede949e8acf521cd8cf970"
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
