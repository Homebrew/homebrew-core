class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2025/sqlite-src-3490100.zip"
  version "3.49.1"
  sha256 "4404d93cbce818b1b98ca7259d0ba9b45db76f2fdd9373e56f2d29b519f4d43b"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c14de55cd3a85bc71e62f7cdc37577a353250190103d0e5cbd49e8a753e6c995"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a064a8eb15e229554511dfa3c5dd0603841fa1eaf1fb94e7f823fca54c73bed9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb97625ffd1c21be1ae93fa6d808c88f1d9e03b6aa74f009bd0223394bda2efd"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d2265afacdfd04a529a59f964642ab32c6cf471914821e4a402aa5965b5649c"
    sha256 cellar: :any_skip_relocation, ventura:       "6458b1dd31e4b39b419a9a1cb7354c565674bd7af709f274c74556bd65a53f00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "629d95550982e606bc6cedb92aa23813ec135218f4bf8db28dd7148238082099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e0b6c41fed8092747d24c9311ca516223e76698790abc12d7d0eb83bf0b9882"
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
