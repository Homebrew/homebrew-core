class Brainfuck < Formula
  desc "Interpreter for the brainfuck language"
  homepage "https://github.com/fabianishere/brainfuck"
  license "Apache-2.0"
  head "https://github.com/fabianishere/brainfuck.git", branch: "master"

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
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "c7c0b45b6d596c3fd5e83156331b7595521249b34c443518d5a757a937551046"
    sha256 cellar: :any,                 big_sur:       "7b128f991009e1e9b4e5ce31b451f49d7aaab01b4a7867ce8709483dee4e8bea"
    sha256 cellar: :any,                 catalina:      "e6df5d077a5a75d2f350064f7d8aab3ac109759ca330753f974c9bd23043a917"
    sha256 cellar: :any,                 mojave:        "ede2edc346ff8bfff8829ced2ec99ef0df74edf6978fb2541bbaa7daa53f8d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38510b863336aac8bf1c37a49c74a41451c7cfa7f3cd78de7bc7be27f953f242"
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
