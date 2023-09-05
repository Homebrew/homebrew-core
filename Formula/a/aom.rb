class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.7.0",
      revision: "6054fae218eda6e53e1e3b4f7ef0fff4877c7bf1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f7a81f29292f9576c49af4be37c5d331eb0ba806d585138d0a6200cab8bf9951"
    sha256 cellar: :any,                 arm64_monterey: "08e410f001ded1db57e919b808337ed20065d7b1287ddeaf3ab20a0640fa02a5"
    sha256 cellar: :any,                 arm64_big_sur:  "fecf629957a4e31d49d93f678c928c59f65713fc8f0d73ce22dc72c80ff988d6"
    sha256 cellar: :any,                 ventura:        "7138ece92df570ff943e43200b6c86c2ccf0318ce6a3c2ca4a447ecf70d22a80"
    sha256 cellar: :any,                 monterey:       "224593a9c4c88274eb176efdfb07ca80b4f51c14556d16a7f47ee9884b57147e"
    sha256 cellar: :any,                 big_sur:        "606a97926132ce0a39a7edcda0dfd6e31174dd47b9cd279f08ffb5585e50e1b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1080a641f1ef2124b869b601197095449ff167a316a19cc4d8e8d8512e63658c"
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
