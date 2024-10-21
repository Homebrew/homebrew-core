class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "https://github.com/DanBloomberg/leptonica/releases/download/1.85.0/leptonica-1.85.0.tar.gz"
  sha256 "3745ae3bf271a6801a2292eead83ac926e3a9bc1bf622e9cd4dd0f3786e17205"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d2d966918337ee5feda18544d4546734f77aeaf4dde87ae8979589bd97c799c1"
    sha256 cellar: :any,                 arm64_sonoma:  "4b742a3445f7a24454ebf897551b8d49fc5cdc2ab7c93fc5a5c6ec4695292ef0"
    sha256 cellar: :any,                 arm64_ventura: "c63d4257101ed2af4aca050ce013a6825ca189ec0f4cea03bdd650ecea77cc71"
    sha256 cellar: :any,                 sonoma:        "97b295e17239dca10dbc284995b439594ad857afa84b9e81b12b6dd597e8daa8"
    sha256 cellar: :any,                 ventura:       "b85f75996d77b388e32d762a3b5c9d70f6a4d6be088353822b57b52c71a4d8b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b2c01e724c093ba4b4bf19bdd65edcc3ff70dbc5071e5e801f07b9f24cc2d63"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "webp"

  uses_from_macos "zlib"

  patch :DATA

  def install
    args = ["-DSTRICT_CONF=ON"]
    shared_args = ["-DBUILD_PROG=ON", "-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]

    system "cmake", "-S", ".", "-B", "build_shared", *args, *shared_args, *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", *args, *std_cmake_args
    system "cmake", "--build", "build_static"
    lib.install "build_static/src/libleptonica.a"

    # Add lept.pc to align with autotools build
    odie "lept.pc already exists!" if (lib/"pkgconfig/lept.pc").exist?
    odie "lept_Release.pc does not exist!" unless (lib/"pkgconfig/lept_Release.pc").exist?
    (lib/"pkgconfig").install_symlink "lept_Release.pc" => "lept.pc"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <leptonica/allheaders.h>

      int main() {
        printf("%d.%d.%d", LIBLEPT_MAJOR_VERSION, LIBLEPT_MINOR_VERSION, LIBLEPT_PATCH_VERSION);
        writeImageFileInfo("#{test_fixtures("test.png")}", stderr, 0);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lleptonica"
    assert_equal version.to_s, shell_output("./test 2>#{testpath}/stderr.log")
    assert_match <<~TEXT, (testpath/"stderr.log").read
      Reading the header:
        input image format type: png
        w = 8, h = 8, bps = 1, spp = 1, iscmap = 1
        xres = 0, yres = 0
    TEXT
  end
end

__END__
diff --git a/prog/CMakeLists.txt b/prog/CMakeLists.txt
index 73fd28b5..6626ba25 100644
--- a/prog/CMakeLists.txt
+++ b/prog/CMakeLists.txt
@@ -15,7 +15,7 @@ function(add_prog_target target)
     if (BUILD_SHARED_LIBS)
         target_compile_definitions  (${target} PRIVATE -DLIBLEPT_IMPORTS)
     endif()
-    if(FREEBSD AND HAVE_LIBM AND ${target} MATCHES ${math_progs})
+    if((FREEBSD OR CMAKE_SYSTEM_NAME STREQUAL "Linux") AND HAVE_LIBM AND ${target} MATCHES ${math_progs})
       target_link_libraries         (${target} leptonica m)
     else()
       target_link_libraries         (${target} leptonica)
