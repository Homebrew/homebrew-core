class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.0.12.tar.gz"
  sha256 "d5f9d5dcb95c52f7b243b1b818a34be99cecaaa5afd6de1c5b2502214f5df7f7"
  license any_of: ["QPL-1.0", "GPL-2.0-only", "GPL-3.0-only"]
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "9d84cf5b0d9e4826ab22a0637fb710291bb6e35f826570ab9cb666953440c95d"
    sha256 arm64_ventura:  "6e4df7eeb2d5a1ef885b69bcf5c1d30604d0d9253f6bada64617f86a5565aa2a"
    sha256 arm64_monterey: "e493590d96d19cead1c33eee06584f088c866f793c9e2917d96887f9ff5b7892"
    sha256 sonoma:         "55930073bc333b96eab02936a6054292ccbe0cee6b3baa4287f3f7f2c5c3f346"
    sha256 ventura:        "44ee2029820770e2467c3f1fcb499c4c9cfa00af58393fa8542ca092ce76a9ae"
    sha256 monterey:       "64bc2ea49da72d28c41771de713077af4f32b04199be93a4dcc4d958d565f45e"
    sha256 x86_64_linux:   "de44d62ab4c6342b5ec2d14007b16cf00ca18af6491dfa22779f2fdd3f4fb8c6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "llvm"
  end

  fails_with :gcc

  patch :DATA

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    inreplace bin/"objfw-config", "llvm_clang", "clang" if OS.linux?
  end

  test do
    system "#{bin}/objfw-new", "--app", "Test"
    system "#{bin}/objfw-compile", "-o", "t", "Test.m"
    system "./t"
  end
end

__END__
diff --git a/build-aux/m4/buildsys.m4 b/build-aux/m4/buildsys.m4
index 3ec1cc5c..c0c31cac 100644
--- a/build-aux/m4/buildsys.m4
+++ b/build-aux/m4/buildsys.m4
@@ -323,7 +323,7 @@ AC_DEFUN([BUILDSYS_FRAMEWORK], [
 		AS_IF([test x"$host_is_ios" = x"yes"], [
 			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,@executable_path/Frameworks/$$out/$${out%.framework}'
 		], [
-			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,@executable_path/../Frameworks/$$out/$${out%.framework}'
+			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,${prefix}/Library/Frameworks/$$out/$${out%.framework}'
 		])
 
 		AC_SUBST(FRAMEWORK_LDFLAGS)

