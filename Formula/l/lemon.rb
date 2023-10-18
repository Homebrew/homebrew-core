class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2023/sqlite-src-3430200.zip"
  version "3.43.2"
  sha256 "eb6651523f57a5c70f242fc16bc416b81ed02d592639bfb7e099f201e2f9a2d3"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "130b160b8000c7d819caa05782136834b4eb78208a17bfedf481281a3a69a646"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5df53c4eb772df8410a1eb69d3d0d67b7eb573a324295939d97cd7ccbb41173"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a776492ac142dc5f208185c64dc782caea12e0728215de4f2970756844743597"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e660a9424991b751a183e878a9c2fb89a83040ed344bdc5d0410a78aa36e1a3"
    sha256 cellar: :any_skip_relocation, ventura:        "3569d26ef183206b9749d8dc8ce6162f6bdd5c8c1293e8740229c18e0dc82409"
    sha256 cellar: :any_skip_relocation, monterey:       "1fc6fc56eabe02e427889c8c2bc4a54e68bcdba0aacd53e7b90b7d5735453175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1ba4f205faf98a57b910563a0bcb58337ffefad3da0be5cc357f2bd6c6b011a"
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
