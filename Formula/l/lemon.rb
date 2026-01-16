class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://sqlite.org/2026/sqlite-src-3510200.zip"
  version "3.51.2"
  sha256 "85110f762d5079414d99dd5d7917bc3ff7e05876e6ccbd13d8496a3817f20829"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "740ef01b148dfe74d6498302e2ebee6c885c5762d589a389cda16b80655459bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db83aa4484bf1bd9e7f1e6629315e6fe39c6e8287bef635f80fd46a77d6c2f32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d1447067daeb90c57e124931a43e2f38c1597c19e9df0576cb31545e95e1166"
    sha256 cellar: :any_skip_relocation, tahoe:         "a5058c23cc1ef24fd9ad7441d21b0a9e88f6e54a5a40b291cec4362e6ef22a8e"
    sha256 cellar: :any_skip_relocation, sequoia:       "f7332c866d0775b85b38dc5383857c637b7da45f1c49d66479eb0d0027119a12"
    sha256 cellar: :any_skip_relocation, sonoma:        "837afa1123340edb2a2e270b338d7160b06773b1c9018bf63207e93407ed846d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6aaa0d428228fd63aabb3a1a07976159cb2f5a31b89b9bff059c655a3760b299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f43b6eba78b8632febb98d0265e64c36aa47659d5c5c7845c00bd3833867a3e"
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
