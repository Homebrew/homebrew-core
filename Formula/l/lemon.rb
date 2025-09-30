class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2025/sqlite-src-3500400.zip"
  version "3.50.4"
  sha256 "b7b4dc060f36053902fb65b344bbbed592e64b2291a26ac06fe77eec097850e9"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5508c5c43d012d2ad19faa86cc6f1ff23a3a362d8a63fdebd78e81ba948837e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ed0f53dccb0b2c94185959f261fce4a908cca7b28b4d969b03d62a9a7e3955a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9bf8630d59939a11082878bc5b5c4f73ca59619876eb91b8d19c0900802be03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8841bfca461106dca5ccddbdf40ff57203ff0cb9f244e65e91acd5e6d230cada"
    sha256 cellar: :any_skip_relocation, tahoe:         "804c9c2e24a5de7c49251b36a755d98868ba0ca5a145fcf5fcc9f34e42c560e0"
    sha256 cellar: :any_skip_relocation, sequoia:       "9fc3ceb65fbe6966495f3e2c9932b2ba909e1ed990b4cd548f0adc8c9cdeb514"
    sha256 cellar: :any_skip_relocation, sonoma:        "66acf5036781b2957d9cc7d1e752356c43c68e46906eca92884acfd4cd73b007"
    sha256 cellar: :any_skip_relocation, ventura:       "a6c6c93c3f0876cd111e00bad811237c6149975aed24263ea6a1a7a8567c6530"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58f1fe72b2ada76de1835d1cd2e4caf4c1588efbe6968abc42466e2597d48e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56d6a430b030e982a715e88d5fb037b5c109ff4e321bdb8e0b861f76777086e9"
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
