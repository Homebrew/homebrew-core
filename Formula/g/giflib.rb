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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "aab2a621b970bab0baf55c4cd72cebd118a7e283a3a0ce4a85a91546707df2f1"
    sha256 cellar: :any,                 arm64_sequoia:  "bf188a3d3e386e0b100831ca92173118c74645b033b56b4a7c148a91c2cfecb5"
    sha256 cellar: :any,                 arm64_sonoma:   "c6b05aecad00588daf749dbde717fb6a03ce83fb9723b15f5786e7b974ef4c02"
    sha256 cellar: :any,                 arm64_ventura:  "f0c469da58fa4384fb67b249b4869f3daced90a8326e520aeb2a030af54ccc48"
    sha256 cellar: :any,                 arm64_monterey: "3089db3525957dedba2e0297997fe5bc6f3add879464102e48257ac12775cff7"
    sha256 cellar: :any,                 sonoma:         "40d390aab5bc396eb3efa0ae00987efd8c9eb8049239f709f486a879577a41ef"
    sha256 cellar: :any,                 ventura:        "b3d5cfa490fb61890dceb4b49510171783ab0e4dfc6f64f2f5f8ee1cecc08013"
    sha256 cellar: :any,                 monterey:       "1b8828d26eeaccc1f3cefdbc41bd55551045d1ae55a18a1c96f4d27bd214df17"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "162732cc2ffcd48bfb68353fc4b454e6fbd5c2316b15eb6d98cbe8926f3ecb25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db5d2754722a81e5a842a66236aeebe889ebae26b08329dbd506007b9e63339c"
  end

  # Move logo resizing to be a prereq for giflib website only, so that imagemagick is not required to build package
  # Remove this patch once the upstream fix is released:
  # https://sourceforge.net/p/giflib/code/ci/d54b45b0240d455bbaedee4be5203d2703e59967/
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
index d9959d5..91b0b37 100644
--- a/doc/Makefile
+++ b/doc/Makefile
@@ -46,13 +46,13 @@ giflib-logo.gif: ../pic/gifgrid.gif
 	convert $^ -resize 50x50 $@
 
 # Philosophical choice: the website gets the internal manual pages
-allhtml: $(XMLALL:.xml=.html) giflib-logo.gif
+allhtml: $(XMLALL:.xml=.html)
 
 manpages: $(XMLMAN1:.xml=.1) $(XMLMAN7:.xml=.7) $(XMLINTERNAL:.xml=.1)
 
 # Prepare the website directory to deliver an update.
 # ImageMagick and asciidoc are required.
-website: allhtml
+website: allhtml giflib-logo.gif
 	rm -fr staging; mkdir staging; 
 	cp -r $(XMLALL:.xml=.html) gifstandard whatsinagif giflib-logo.gif staging
 	cp index.html.in staging/index.html
