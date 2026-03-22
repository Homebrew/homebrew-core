class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://sqlite.org/2026/sqlite-src-3510300.zip"
  version "3.51.3"
  sha256 "f8a67a1f5b5cae7c6d42f0994ca7bf1a4a5858868c82adc9fc1340bed5eb8cd2"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c7bb26090126cbea0b2fefa4f9bbb2fc4fdf623ee23a9d8f95a543e33886bdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3e870ef6d0be4833709f7cc3f7ca404f87fc3dba7e93f3dab7987a574109e6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfd956f08549a5315c8a94cbc0356ebb9de6e0eaf19511576407f2e7be2d36f0"
    sha256 cellar: :any_skip_relocation, tahoe:         "e2c95f602211d6e8811c8cd4434bcd037426277645edbe09d5be6c1c9ff29f18"
    sha256 cellar: :any_skip_relocation, sequoia:       "8935f6d67e500ebaa036812e4a5721ca8051530513bc3135e1b8bbf117bbe502"
    sha256 cellar: :any_skip_relocation, sonoma:        "a34354e6ebe1d55a772cec79dfbb8ee6cd3d9ec76a3423230656e6b2f16e0d75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04b0bdbef3b291b742f45d219201013a353ef6b6c206da304b2fa3f1fb1af9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c97987d8f30e5090e9b18f92e7d1a9ffc9750c345e8e09812096875cb649267f"
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
