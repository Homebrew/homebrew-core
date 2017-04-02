class Ohcount < Formula
  desc "Source code line counter"
  homepage "https://github.com/blackducksw/ohcount"
  url "https://github.com/blackducksw/ohcount/archive/3.0.0.tar.gz"
  sha256 "46ef92e1bbf9313de507a03decaf8279173584555fb580bb3d46d42c65aa4a6d"

  bottle do
    cellar :any
    sha256 "b3d4be11858ec755a35d97259c145a76d64ee2e3c0e776cc81578a323b549399" => :sierra
    sha256 "4c6ca73681e204052237392b9c931e46fcdd599c6605bfc7861e3e91dce9ceac" => :el_capitan
    sha256 "08d9df78da1afb3654e96fa142db9eb1981dbbc14861db522dae6e8cc08791e4" => :yosemite
    sha256 "055b2eb9460b1723bcb8a0f215ddda35750ce6d9b9c3cd0bce75d4e9584f0b62" => :mavericks
  end

  head do
    url "https://github.com/blackducksw/ohcount.git"
    depends_on "libmagic"
  end

  depends_on "ragel"
  depends_on "pcre"

  patch :DATA

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    system "./build", "ohcount"
    bin.install "bin/ohcount"
  end

  test do
    path = testpath/"test.rb"
    path.write "# comment\n puts\n puts\n"
    stats = `#{bin}/ohcount -i #{path}`.split("\n")[-1]
    assert_equal 0, $?.exitstatus
    assert_equal ["ruby", "2", "1", "33.3%"], stats.split[0..3]
  end
end

__END__
--- a/build
+++ b/build
@@ -29,7 +29,7 @@ else
   INC_DIR=/opt/local/include
   LIB_DIR=/opt/local/lib
   # You shouldn't have to change the following.
-  CFLAGS="-fno-common -g"
+  #CFLAGS="-fno-common -g"
   WARN="-Wall -Wno-parentheses"
   SHARED="-dynamiclib -L$LIB_DIR -lpcre"
   SHARED_NAME=libohcount.dylib
@@ -38,7 +38,7 @@ else
 fi
 
 # C compiler and flags
-cc="gcc -fPIC -g $CFLAGS $WARN -I$INC_DIR -L$LIB_DIR"
+cc="$CC $CFLAGS -O0 $WARN $CPPFLAGS $LDFLAGS"
 
 # Ohcount source files
 files="src/sourcefile.c \
