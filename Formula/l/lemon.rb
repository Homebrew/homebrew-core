class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2025/sqlite-src-3480000.zip"
  version "3.48.0"
  sha256 "2d7b032b6fdfe8c442aa809f850687a81d06381deecd7be3312601d28612e640"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91cb68ae462c0121b92f0fe141480dd9de2e609ee0c27fc9da122912e250c2a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cafedf5ef35351b05e795f2dc50c95039fbb39c1fdc0c6f8f2f3018ddf0b42d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75c664db3b27df85c9d88d12697f314535c8fb7431b8e7d4db5093dd1d0cae08"
    sha256 cellar: :any_skip_relocation, sonoma:        "a50ec3bff93951d0615cc09555ab47534922f35741e4a38d796a40e9b1965e3a"
    sha256 cellar: :any_skip_relocation, ventura:       "0948ebb5ea0c4cc00a0dcc7a9544d44e183e9650f7e85e4b4652b6471bd3d03f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f03aaa8f0e5ad14494abf0f8f89421dadd233d6ee09cd7ce141dbe4fa9104dac"
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
