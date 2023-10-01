class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2023/sqlite-src-3430100.zip"
  version "3.43.1"
  sha256 "22e9c2ef49fe6f8a2dbc93c4d3dce09c6d6a4f563de52b0a8171ad49a8c72917"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ccab3d89ea2609c2c989205dea68aadd7c9ba175123a0c777a23206d7c06527"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37fc590f3d6468fbaf2003f32a1fab5d99407a2d4aa9d47759e394eab000e185"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "945a1930f1864ee33487a5d502b175089c390874cf4d2443887625acb6328728"
    sha256 cellar: :any_skip_relocation, ventura:        "e995b59e7b42df4716c7455c23a9022a876f7fdf418af79dbbe5b081f7ff5f72"
    sha256 cellar: :any_skip_relocation, monterey:       "df23397377f60d8f534f252590b3fdf1af714b5461b4583737542e8f39e41b91"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3d63e6c12c7b718a0b8047b0fe5cf8b37010e0508d66216ef21d5d204b72216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4b447054ad52c7bb38c444e52777fcbaf3e26c77ee743d5c156fc14df759ff8"
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
