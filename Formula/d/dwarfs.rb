class Dwarfs < Formula
  desc "Fast high compression read-only file system for Linux, Windows, and macOS"
  homepage "https://github.com/mhx/dwarfs"
  url "https://github.com/mhx/dwarfs/releases/download/v0.12.3/dwarfs-0.12.3.tar.xz"
  sha256 "bd2d54178c59e229f2280eea747479a569e6f6d38340e90360220d00988f5589"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "a9fc4090c324b1ddd643877b581816d822474176461e41d5d6efc2dad98e0ba8"
    sha256                               arm64_sonoma:  "8c89ad5dba6e5e2d6e5372df63b17818cb7af1f92315b869e93dafb78e2f16a1"
    sha256                               arm64_ventura: "9af18fafdafba36e43fb9fd2f50c3ff17cf009b249edd7d928f1ec1d88c504d1"
    sha256 cellar: :any,                 sonoma:        "57f4b2d86982ac3686caceff3d585a89ab106d44c061b5c5c93e01cca03b4918"
    sha256 cellar: :any,                 ventura:       "fe57fcde38aba3428efe8d7a86bac7f12bf719a3dc1b67ebc2932503a0c93cac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b88621d3cad01d5cdc88f42ac6893ef90c1b2fb10f77d62279eae467cccb7179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d71de04d05ce83c44020eb984fe854b3875caa57abd98a99000d860c82d2d410"
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

  # Backport folly fix for LLVM 20
  patch do
    url "https://github.com/facebook/folly/commit/ef5160f6b02fb8eb971adf7edd3aea96ef73bc66.patch?full_index=1"
    sha256 "66db8650dc30d285064fcccb93c5d4e7384cefae091b1fc76eddede279271332"
    directory "folly"
  end

  # Apply folly fix for LLVM 20 from https://github.com/facebook/folly/pull/2404
  patch do
    url "https://github.com/facebook/folly/commit/1215a574e29ea94653dd8c48f72e25b5503ced18.patch?full_index=1"
    sha256 "14a584c4f0a166d065d45eb691c23306289a5287960806261b605946166de590"
    directory "folly"
  end

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
