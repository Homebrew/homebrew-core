class Giflib < Formula
  desc "Library and utilities for processing GIFs"
  homepage "https://giflib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-5.2.2.tar.gz"
  sha256 "be7ffbd057cadebe2aa144542fd90c6838c6a083b5e8a9048b8ee3b66b29d5fb"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{url=.*?/giflib[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0810045224fbfa1ae8c5bbdfc44d454efcaf76606e865f8be4a46606369c44b1"
    sha256 cellar: :any,                 arm64_ventura:  "ced5a24b12f7057504aa8821a81c03c4d83ff6ba861487e25eba34b863237c20"
    sha256 cellar: :any,                 arm64_monterey: "6a1194d7b2d991583e3b5d46782ac8d0cecfc35bc28a5b4daf86ec4311cc7cdc"
    sha256 cellar: :any,                 arm64_big_sur:  "e9a78b55a43f68f2552f845fff27d1c247ed865b1dd653f4c8ab259594411f86"
    sha256 cellar: :any,                 sonoma:         "84a39bf9c63c3a0fd781c994921f012b5d34bcb8ab39105909453d8635488337"
    sha256 cellar: :any,                 ventura:        "7b542ce4281136276979dfbe45cea1a84060f624ee307917c24499398b210103"
    sha256 cellar: :any,                 monterey:       "fa6adb4afc1abd76f8a80afd8c25572f7c990cbfc88a43496350e8c363048217"
    sha256 cellar: :any,                 big_sur:        "dc23500f50d599c4dbfcea0107b643bef41538c2f5fd162b049f82d21e3d32d5"
    sha256 cellar: :any,                 catalina:       "ad97d175fa77f7afb4a1c215538d8ae9eff30435de7feaa6a5d2e29fca7fef4d"
    sha256 cellar: :any,                 mojave:         "42d2f8a6e9dbf9d4c22a2e64581c7170cc7dcb2a0e66df383efc67b7bc96238d"
    sha256 cellar: :any,                 high_sierra:    "e1a30a20ad93cd9ec003027d7fba43a7e04ced0bff4156614818cccfc9dec6c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d753208ed3a4bbd60b59e3ca4466196e4b935d4f434935b540fc6bfb5f3e0385"
  end

  # remove gif file resizing step so that no need to have imagemagick installed
  patch :DATA

  def install
    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/giftext #{test_fixtures("test.gif")}")
    assert_match "Screen Size - Width = 1, Height = 1", output
  end
end

__END__
diff --git a/doc/Makefile b/doc/Makefile
index b34ece0..ab599e7 100644
--- a/doc/Makefile
+++ b/doc/Makefile
@@ -46,14 +46,14 @@ giflib-logo.gif: ../pic/gifgrid.gif
 	convert $^ -resize 50x50 $@

 # Philosophical choice: the website gets the internal manual pages
-allhtml: $(XMLALL:.xml=.html) giflib-logo.gif
+allhtml: $(XMLALL:.xml=.html)

 manpages: $(XMLMAN1:.xml=.1) $(XMLMAN7:.xml=.7) $(XMLINTERNAL:.xml=.1)

 # Prepare the website directory to deliver an update.
 # ImageMagick and asciidoc are required.
 website: allhtml
-	rm -fr staging; mkdir staging;
-	cp -r $(XMLALL:.xml=.html) gifstandard whatsinagif giflib-logo.gif staging
+	rm -fr staging; mkdir staging;
+	cp -r $(XMLALL:.xml=.html) gifstandard whatsinagif staging
 	cp index.html.in staging/index.html
 	asciidoc - <../history.adoc >staging/history.html
