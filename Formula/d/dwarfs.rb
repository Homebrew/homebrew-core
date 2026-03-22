class Dwarfs < Formula
  desc "Fast high compression read-only file system for Linux, Windows, and macOS"
  homepage "https://github.com/mhx/dwarfs"
  url "https://github.com/mhx/dwarfs/releases/download/v0.15.1/dwarfs-0.15.1.tar.xz"
  sha256 "a180086f9a898b4b52a5217e336c0134d63a10b395b493f2e19f231d575a87ec"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "b243a2802993dec638cea437a9c9e45ad5934676b9ecaa584c846f5fb0f3eec5"
    sha256                               arm64_sequoia: "1cff8a70137098c0ce4e98adbf798f856f29fd91ca52bc46aeefed665bce32a5"
    sha256                               arm64_sonoma:  "f237adf0136b796f67eda9f6e536476be0e1ff99690e44574a6a3088fe0d0958"
    sha256 cellar: :any,                 sonoma:        "3d0e905406c9a3765382d6847ca84f0564b1ff155392e5e80f47110b5559551a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbea34a7d08497160c1b4562af538cd42fa3669ea237c4b29041fa484b2e86e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e60ac81e633d27a38f194b7ccf38eb2ad7448f771756f39c03802f9ad62a298f"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "brotli"
  depends_on "flac"
  depends_on "fmt"
  depends_on "howard-hinnant-date"
  depends_on "libarchive"
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
    cause "Not all required C++23 features are supported"
  end

  # Temporary fix for missing dependency on Boost::program_options
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
    assert_operator 10, :<=, info["inode_count"]

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

    system ENV.cxx, "-std=c++23", "test.cpp", "-I#{include}", "-L#{lib}", "-Wl,-rpath,#{lib}",
                    "-o", "test", "-ldwarfs_common"

    assert_equal version.to_s, shell_output("./test").chomp
  end
end

__END__
--- a/cmake/libdwarfs.cmake
+++ b/cmake/libdwarfs.cmake
@@ -335,6 +335,12 @@ target_link_libraries(
   dwarfs_fsst
 )
 
+target_link_libraries(
+  dwarfs_writer
+  PRIVATE
+  Boost::program_options
+)
+
 if(TARGET Boost::process)
   target_link_libraries(dwarfs_common PUBLIC Boost::process)
 endif()
