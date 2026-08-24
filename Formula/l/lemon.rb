class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2026/sqlite-src-3530400.zip"
  version "3.53.4"
  sha256 "d18fa15aec74d8c17e1463f861095adc01b5ad190256acb4f91d22f0368d232b"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3b362f10c4d35707009d136e57159a5321a189c26f6efe9b90a7d5e049b1590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c71a685d8a98cd313cec9a0257ad0ae2b467e1ca5cba6aa5dea8dc24140e30de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a43947c5ef1e8b7998ed161f5e5a1cc7566022d6d89bd27ce59bcae3f6b6f5ad"
    sha256 cellar: :any_skip_relocation, tahoe:         "6ebe196fb9a42e18f1d0b7aa9a71aa30e3382dcaadc927c25af05af5880369b0"
    sha256 cellar: :any_skip_relocation, sequoia:       "fa1f795de49048902299fbd80e9fe7e8e673530eb8eea3ec2a298d324cbb68ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "eddc5cc605cd97bace0cc4980013969793fdec6a848da53bb3f8628364ef3837"
    sha256 cellar: :any,                 arm64_linux:   "8fce46228b69100ec76ac4ae01ad28172a48e4ec5ccb755e0c56d964f618d080"
    sha256 cellar: :any,                 x86_64_linux:  "bc31dfb45d1575979e985b639e172413e3a0953906d5003b5aff76cc5a535d5b"
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
