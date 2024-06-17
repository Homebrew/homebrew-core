class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2024/sqlite-src-3460000.zip"
  version "3.46.0"
  sha256 "070362109beb6899f65797571b98b8824c8f437f5b2926f88ee068d98ef368ec"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5a2322a79b805b834578b7636fd794c8a4602e541d8708040e2dda73d0ca2fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbd9f3a5d07fd62e1bc443885df04dd47c4706d821b181c225a4bb6e79b493dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30ef3b8c6179193e2dbd6eb124c841c2878ceb2082da0c63a0e162ef1f185a77"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e4e0afd18377c127e7595b56a2b3a5f3b8cbe2e1bb17d5f07bd70dc2375ae65"
    sha256 cellar: :any_skip_relocation, ventura:        "0a79fbd2c46f5add9fc8f361538a2c3e78e5d6061be2bcc7c182cfc4621c7200"
    sha256 cellar: :any_skip_relocation, monterey:       "05ca210bb772c4a1d89c5b19beb152eec8702e3c057d4f6c3676c7cf679a5dc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa48e9309a606760ca839c1ed57f135fa9ef1ffc9972fa30330d0205002590ab"
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
