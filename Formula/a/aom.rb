class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.8.0",
      revision: "b681eac83963950afc7be55df56c22fa5210aaa2"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cb4fff67b23992cdac1190e2e519e9bd110facfcc3ae8a7bea626eed706267b6"
    sha256 cellar: :any,                 arm64_ventura:  "f057d8a8f56fc40cfee61e8a0e59c8f116965e93dda28249063262cc1747b211"
    sha256 cellar: :any,                 arm64_monterey: "f0ff69a82a6a7eb4c299358fa079643995ee850873836f46f71b1a23b1638c87"
    sha256 cellar: :any,                 sonoma:         "641c6a30080e42660c171fbd22c707a20ad093688ebd1cecfe5f02fb97abe387"
    sha256 cellar: :any,                 ventura:        "24abebb2a8d24bf5cebfaacd461ac84f4e37aa9585f9c45ffc9b643d981875cb"
    sha256 cellar: :any,                 monterey:       "4a7da5e7b7431bcb2c0e46d332a36058d04e2f3b15473eb6947e75a5af7010b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "033a3ade47c5141a40a27c23ed7932bf85a33861421b68397c10abfa194d6ecf"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg-xl"
  depends_on "libvmaf"

  on_intel do
    depends_on "yasm" => :build
  end

  resource "homebrew-bus_qcif_15fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
    sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
  end

  # Fix build on arm64 macOS.
  # https://aomedia-review.googlesource.com/c/aom/+/180942
  patch :DATA

  def install
    ENV.runtime_cpu_detection

    args = [
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DENABLE_DOCS=off",
      "-DENABLE_EXAMPLES=on",
      "-DENABLE_TESTDATA=off",
      "-DENABLE_TESTS=off",
      "-DENABLE_TOOLS=off",
      "-DBUILD_SHARED_LIBS=on",
      "-DCONFIG_TUNE_BUTTERAUGLI=1",
      "-DCONFIG_TUNE_VMAF=1",
    ]

    system "cmake", "-S", ".", "-B", "brewbuild", *std_cmake_args, *args
    system "cmake", "--build", "brewbuild"
    system "cmake", "--install", "brewbuild"
  end

  test do
    resource("homebrew-bus_qcif_15fps.y4m").stage do
      system "#{bin}/aomenc", "--webm",
                              "--tile-columns=2",
                              "--tile-rows=2",
                              "--cpu-used=8",
                              "--output=bus_qcif_15fps.webm",
                              "bus_qcif_15fps.y4m"

      system "#{bin}/aomdec", "--output=bus_qcif_15fps_decode.y4m",
                              "bus_qcif_15fps.webm"
    end
  end
end

__END__
diff --git a/build/cmake/aom_configure.cmake b/build/cmake/aom_configure.cmake
index 6c932e86c8..917e7cac5d 100644
--- a/build/cmake/aom_configure.cmake
+++ b/build/cmake/aom_configure.cmake
@@ -184,7 +184,9 @@ if(AOM_TARGET_CPU STREQUAL "x86" OR AOM_TARGET_CPU STREQUAL "x86_64")
   string(STRIP "${AOM_AS_FLAGS}" AOM_AS_FLAGS)
 elseif(AOM_TARGET_CPU MATCHES "arm")
   if(AOM_TARGET_SYSTEM STREQUAL "Darwin")
-    set(CMAKE_ASM_COMPILER as)
+    if(NOT CMAKE_ASM_COMPILER)
+      set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER})
+    endif()
     set(AOM_AS_FLAGS -arch ${AOM_TARGET_CPU} -isysroot ${CMAKE_OSX_SYSROOT})
   elseif(AOM_TARGET_SYSTEM STREQUAL "Windows")
     if(NOT CMAKE_ASM_COMPILER)
