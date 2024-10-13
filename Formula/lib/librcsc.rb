class Librcsc < Formula
  desc "RoboCup Soccer Simulator library"
  homepage "https://github.com/helios-base/librcsc"
  url "https://github.com/helios-base/librcsc/archive/refs/tags/rc2024.tar.gz"
  sha256 "81a3f86c9727420178dd936deb2994d764c7cd4888a2150627812ab1b813531b"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "cf6fd6b7ec4c1edbf8554e45217d35af20109709806f656fdc2ba76a8b345a53"
    sha256 cellar: :any,                 arm64_sonoma:   "32e10d7512099663cf9488e62504a26234b7335c2d8a3678394001a7e7804ed4"
    sha256 cellar: :any,                 arm64_ventura:  "077a939210847e00dd2ab85f25f0875ea9358baed7ba7dca8ac978688c2b862a"
    sha256 cellar: :any,                 arm64_monterey: "1bb50580e569d0f194faa5559d0bfa0d72bd6ac9402792a1d9dd39fdd9d3b6c2"
    sha256 cellar: :any,                 sonoma:         "4e6daaee921804fbd0fa83b779f312106889ae9b7066e17d8027ada97c9ee56e"
    sha256 cellar: :any,                 ventura:        "fd1e0dfe09e8bdc381eb7f6149dfd6a325fc6b5de42e3e0e1c11dd226c63f1c3"
    sha256 cellar: :any,                 monterey:       "99203b77c967aa6689f992cf0e2d07ea90297fe4d319aaa1d8560893af3fad7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7d6186b22dd38c32f6a0451efd7c9d67a829be9e19b40b0dc55aa87a64d5224"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"

  uses_from_macos "zlib"

  # Add missing header to fix build on Monterey
  # Issue ref: https://github.com/helios-base/librcsc/issues/88
  patch :DATA

  def install
    system "./bootstrap"
    system "./configure", "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <rcsc/rcg.h>
      int main() {
        rcsc::rcg::PlayerT p;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-L#{lib}", "-lrcsc"
    system "./test"
  end
end

__END__
diff --git a/rcsc/rcg/parser_simdjson.cpp b/rcsc/rcg/parser_simdjson.cpp
index 47c9d2c..8218669 100644
--- a/rcsc/rcg/parser_simdjson.cpp
+++ b/rcsc/rcg/parser_simdjson.cpp
@@ -43,6 +43,7 @@

 #include <string_view>
 #include <functional>
+#include <unordered_map>

 namespace rcsc {
 namespace rcg {
