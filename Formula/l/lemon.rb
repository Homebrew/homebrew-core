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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b31c0471cd410a7988e59c89063678d633278373782657fb9f13c6515bf7e04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcb740cd3a4f36c6466920d1ebdcfff38111fe6bd39615423df964e19b2cabf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e80c7bf91d48639d66137014e293713ec9a7d03120d815144f31cec1f301c53"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac4477fdc12d923efbf47e5ea88f4eb069f189428eccabb72fcd8aa1501bf16c"
    sha256 cellar: :any_skip_relocation, ventura:        "9c082333b2e8dcee1e6ea4ac0a0be909729415b49b9d239530012d6c92bfbbd4"
    sha256 cellar: :any_skip_relocation, monterey:       "119e62e023c45fd1554f3db9b90269a3dd19360f12f2fe854119cb94dd4a5900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4195f77c9ee72eb6cd9300d8a7ee7d097d9a0d5327309d78d6c8b70804b9519e"
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
