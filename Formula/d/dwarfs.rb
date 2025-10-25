class Dwarfs < Formula
  desc "Fast high compression read-only file system for Linux, Windows, and macOS"
  homepage "https://github.com/mhx/dwarfs"
  url "https://github.com/mhx/dwarfs/releases/download/v0.14.1/dwarfs-0.14.1.tar.xz"
  sha256 "620cf27f2e142a5f8fc05552a70704c3bf4df23c3279c6026b3f37954d0529c5"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "741cb17f74eba766025adcaa1d65bc33a99b1feebfdb7949be625efc77b1111c"
    sha256                               arm64_sequoia: "1515201cc3980a4cba442675f11e193eb5920644fc39c67173ce3750f242b0bc"
    sha256                               arm64_sonoma:  "9c94c09ae94a1e796b1a277c6c4bae578428e4dcacccd7e04313bff12f256075"
    sha256 cellar: :any,                 sonoma:        "1c28aaea2630571524c36c7740e613de0463a7a3b21d3ca5196776faef78908f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd30917e87b13a61294bd0e9f06b25bfd83846084bd5d22024a567b976b69dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6692d8573bce29cfb8c08646762679b611dd7c8f017eb12c2daf18107ef834c"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "brotli"
  depends_on "double-conversion"
  depends_on "flac"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "howard-hinnant-date"
  depends_on "libarchive"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "nlohmann-json"
  depends_on "openssl@3"
  depends_on "parallel-hashmap"
  depends_on "range-v3"
  depends_on "utf8cpp"
  depends_on "xxhash"
  depends_on "xz"
  depends_on "zstd"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500
  end

  on_linux do
    depends_on "jemalloc"
  end

  fails_with :clang do
    build 1500
    cause "Not all required C++20 features are supported"
  end

  # Workaround for Boost 1.89.0 until upstream Folly fix.
  # Issue ref: https://github.com/facebook/folly/issues/2489
  # Fix to Undefined symbols for architecture x86_64: "_XXH3_64bits"
  patch :DATA

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_LIBDWARFS=ON
      -DWITH_TOOLS=ON
      -DWITH_FUSE_DRIVER=OFF
      -DWITH_TESTS=ON
      -DWITH_MAN_PAGES=ON
      -DENABLE_PERFMON=ON
      -DTRY_ENABLE_FLAC=ON
      -DENABLE_RICEPP=ON
      -DENABLE_STACKTRACE=OFF
      -DDISABLE_CCACHE=ON
      -DDISABLE_MOLD=ON
      -DPREFER_SYSTEM_GTEST=ON
    ]

    if OS.mac? && DevelopmentTools.clang_build_version <= 1500
      # No ASAN for folly
      ENV.append "CXXFLAGS", "-D_LIBCPP_HAS_NO_ASAN"

      ENV.llvm_clang

      # Needed in order to find the C++ standard library
      # See: https://github.com/Homebrew/homebrew-core/issues/178435
      ENV.prepend "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/unwind -lunwind"
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib/"c++"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # produce a dwarfs image
    system bin/"mkdwarfs", "-i", prefix, "-o", "test.dwarfs", "-l4"

    # check the image
    system bin/"dwarfsck", "test.dwarfs"

    # get JSON info about the image
    info = JSON.parse(shell_output("#{bin}/dwarfsck test.dwarfs -j"))
    assert_equal info["created_by"], "libdwarfs v#{version}"
    assert info["inode_count"] >= 10

    # extract the image
    system bin/"dwarfsextract", "-i", "test.dwarfs"
    assert_path_exists "bin/mkdwarfs"
    assert_path_exists "share/man/man1/mkdwarfs.1"
    assert compare_file bin/"mkdwarfs", "bin/mkdwarfs"

    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <dwarfs/version.h>

      int main(int argc, char **argv) {
        int v = dwarfs::get_dwarfs_library_version();
        int major = v / 10000;
        int minor = (v % 10000) / 100;
        int patch = v % 100;
        std::cout << major << "." << minor << "." << patch << std::endl;
        return 0;
      }
    CPP

    # ENV.llvm_clang doesn't work in the test block
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++" if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    system ENV.cxx, "-std=c++20", "test.cpp", "-I#{include}", "-L#{lib}", "-o", "test", "-ldwarfs_common"

    assert_equal version.to_s, shell_output("./test").chomp
  end
end

__END__
--- a/folly/CMake/folly-config.cmake.in
+++ b/folly/CMake/folly-config.cmake.in
@@ -38,7 +38,6 @@ find_dependency(Boost 1.51.0 MODULE
     filesystem
     program_options
     regex
-    system
     thread
   REQUIRED
 )
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -507,7 +507,7 @@ if(WITH_TESTS OR WITH_BENCHMARKS OR WITH_FUZZ)
   if(WITH_BENCHMARKS)
     target_sources(dwarfs_test_helpers PRIVATE test/test_strings.cpp)
   endif()
-  target_link_libraries(dwarfs_test_helpers PUBLIC dwarfs_reader dwarfs_writer dwarfs_tool)
+  target_link_libraries(dwarfs_test_helpers PUBLIC dwarfs_reader dwarfs_writer dwarfs_tool PkgConfig::XXHASH)
   set_property(TARGET dwarfs_test_helpers PROPERTY CXX_STANDARD ${DWARFS_CXX_STANDARD})
   target_compile_definitions(dwarfs_test_helpers
        PUBLIC TEST_DATA_DIR=\"${CMAKE_SOURCE_DIR}/test\"