class Librcsc < Formula
  desc "RoboCup Soccer Simulator library"
  homepage "https://github.com/helios-base/librcsc"
  url "https://github.com/helios-base/librcsc/archive/refs/tags/rc2024.tar.gz"
  sha256 "81a3f86c9727420178dd936deb2994d764c7cd4888a2150627812ab1b813531b"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "3d9d528cd8cfa66f49e6a5a371a4f93a2ceac383985a9189627bfd901006b9c7"
    sha256 cellar: :any,                 arm64_sonoma:  "8fde29d988114c1ad006242a6e5ff6d76da689505116521fd8581c44f3c1f6b1"
    sha256 cellar: :any,                 arm64_ventura: "2ef3bfaa135d7dcdfa214b56ec141bdac11882fb307a6aaa4415fda4a982aad8"
    sha256 cellar: :any,                 sonoma:        "d4887f6f0256c8c55347ef86c671a712b3b8b07e52ff691899197a4ecb40ac90"
    sha256 cellar: :any,                 ventura:       "d91b3e133981705b317d6a74a48f821a13c3e83d1ea53f27a8b087c6087cfe2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30a6bd68f775c4ca1091551b26fed7f25c9a00538ca9b29eec04282835d3c425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77dd0bd9e1b3c8971a4eca3430b49648f944824d1a6fc0337696c846372ca9b2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "libtool" => :build

  uses_from_macos "zlib"

  # Add missing header to fix build on Monterey
  # Issue ref: https://github.com/helios-base/librcsc/issues/88
  patch :DATA

  def install
    # Strip linkage to `boost`
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    system "./bootstrap"
    system "./configure", "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <rcsc/rcg.h>
      int main() {
        rcsc::rcg::PlayerT p;
        return 0;
      }
    CPP
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
