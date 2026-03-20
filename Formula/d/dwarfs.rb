class Dwarfs < Formula
  desc "Fast high compression read-only file system for Linux, Windows, and macOS"
  homepage "https://github.com/mhx/dwarfs"
  url "https://github.com/mhx/dwarfs/releases/download/v0.15.0/dwarfs-0.15.0.tar.xz"
  sha256 "790f3bae70f18e9a6b27d821986fcdb72f00f6c821bf7466eb4b228c19ae78d7"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "667971918a01d9ecf9a68e517419556518f40b1a88d129f7388e3c056dde20e1"
    sha256                               arm64_sequoia: "010a72e9d50722ae75da2b9a90184ba3944b7209201f2727555f75bbb58adcd8"
    sha256                               arm64_sonoma:  "88707bafc55681104dbe8ebc27cdd8320ae4efadf01052029ec8ecbec1e8ab6c"
    sha256 cellar: :any,                 sonoma:        "c92cfb03e437391045d4f409b721430d908f5f79b9cf45679b4c683da3b48545"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "163fe1b1433eb1a91a5c1f7298176eacd3575532f6312110b35d515303a34561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c34707a0aa4b50b2679ca80a577ebaf8ba068e59254a695fe391e4b5b6a3a280"
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
