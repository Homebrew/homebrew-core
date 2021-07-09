class Brainfuck < Formula
  desc "Interpreter for the brainfuck language"
  homepage "https://github.com/fabianishere/brainfuck"
  license "Apache-2.0"
  head "https://github.com/fabianishere/brainfuck.git"

  # Remove stable block in next release with merged patch
  stable do
    url "https://github.com/fabianishere/brainfuck/archive/2.7.1.tar.gz"
    sha256 "06534de715dbc614f08407000c2ec6d497770069a2d7c84defd421b137313d71"

    # Fix Linux build: "editline/history.h: No such file or directory"
    # Upstream ref: https://github.com/fabianishere/brainfuck/pull/58
    # Extracted part of commit to not apply version number changes
    # Remove in the next release
    patch :DATA
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "560663a6526b7ebc8f4eb49ffa77baaa5d52fd0c4567310ce89adb4e0175c7a5"
    sha256 cellar: :any, big_sur:       "be92f674de1067730847cbfa767bc7ef13ce1507604e6261dcc4244a23a1f75e"
    sha256 cellar: :any, catalina:      "bf49cdb2f3515c537a9ced6a5697be843489b2bf37b3ea732527077e96347f04"
    sha256 cellar: :any, mojave:        "a9e9509e4f0cd5345ffeac741c3a74d5575e17c99ea53822dd77fd4f98687b57"
    sha256 cellar: :any, high_sierra:   "cf3c31fcf7c4cf099b348d01e619d1791aa3a255199de80afbc637e331947abf"
    sha256 cellar: :any, sierra:        "354bb3372301325b49bfd4bd9b53084061af3bc3a3d6375e1c4635297c0dd008"
    sha256 cellar: :any, el_capitan:    "f8289bed7e6455b63f05baf367069f60fe478f6c78f064c06ab1e571a181c3b7"
  end

  depends_on "cmake" => :build
  uses_from_macos "libedit"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_SHARED_LIB=ON",
                         "-DBUILD_STATIC_LIB=ON", "-DINSTALL_EXAMPLES=ON"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/brainfuck -e '++++++++[>++++++++<-]>+.+.+.'")
    assert_equal "ABC", output.chomp
  end
end

__END__
diff --git a/src/main.c b/src/main.c
index 943b08a..649061a 100644
--- a/src/main.c
+++ b/src/main.c
@@ -22,9 +22,6 @@

 #ifdef BRAINFUCK_EDITLINE_LIB
 	#include <editline/readline.h>
-	#ifndef __APPLE__
-		#include <editline/history.h>
-	#endif
 #endif

 #if defined(WIN32) || defined(_WIN32) || defined(__WIN32) && !defined(__CYGWIN__)
