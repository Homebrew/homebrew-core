class Dwarfs < Formula
  desc "Fast high compression read-only file system for Linux, Windows, and macOS"
  homepage "https://github.com/mhx/dwarfs"
  url "https://github.com/mhx/dwarfs/releases/download/v0.13.0/dwarfs-0.13.0.tar.xz"
  sha256 "d0654fcc1219bfd11c96f737011d141c3ae5929620cd22928e49f25c37a15dc9"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "2697e428eef2e29f1e8ae0bf08753a671b57dbc568f12fe8bcff8990f81cb8b5"
    sha256                               arm64_sequoia: "e042bc7ba514d04af91dcab3af3edf91c4d6865fb9aa0b50c5587d1234eb54f5"
    sha256                               arm64_sonoma:  "708b6313f17ef0813e2ba3fe07923f675893953a780e5b3f2b92a348b4b9b283"
    sha256                               arm64_ventura: "0ae44a58627292f7e4ff95b2b74d8420182b3e68d7e7fe3dd595dce6448e3171"
    sha256 cellar: :any,                 sonoma:        "b7ab7c653028882f0688fb1168dc00236117daa712680d1def4366e69ed2f552"
    sha256 cellar: :any,                 ventura:       "9b69ab73a08b78a3d022b46e6f7dade5cf36ed8c4cf5013ff998d95897a0092e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10ccb1ddec2601891528592b6d954f6d54436c487f380b21f7b85e52050cbfbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e3dfa59eb0ed9299160b51b7e169d23f86fa3df76558cdc1ebadd1eed13e6bf"
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
--- a/folly/CMake/folly-deps.cmake
+++ b/folly/CMake/folly-deps.cmake
@@ -41,7 +41,6 @@ find_package(Boost 1.51.0 MODULE
     filesystem
     program_options
     regex
-    system
     thread
   REQUIRED
 )
