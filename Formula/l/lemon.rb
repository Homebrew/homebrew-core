class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://sqlite.org/2025/sqlite-src-3510100.zip"
  version "3.51.1"
  sha256 "0f8e765ac8ea7c36cf8ea9bffdd5c103564f4a8a635f215f9f783b338a13d971"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b059103a2648d45fe5c601ee993e86f1e2ad19c57dbc06d01446a15f064bb4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddcd497466e2bd3b50386620e13c768025cda9296b6558733c45d66a4713d433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddbdbd5b1abca0bc5108a8873dc61b62d3291ac24d16b908efacbf2b654812ab"
    sha256 cellar: :any_skip_relocation, tahoe:         "f401b7983b28fba8d8cf93b20dbed1a36f31cca87e4cdb41b4db4acfa5d8c7bf"
    sha256 cellar: :any_skip_relocation, sequoia:       "05cf0ee05e503bfb768fe2aa8b983c507c121655ff4307c00d4e52d309dee4a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "356f304362e27220b664ad844cc8c90904f17e3a6891512bd07b3fc78b456eba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65d0fc65d81af46a5c326f7099b5e4f6b628eca59651e40799d78f59883c3a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d320aa6008db9177369728aee2beab01ae0511a5f787eeb5d1b8cd6d88294de"
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
