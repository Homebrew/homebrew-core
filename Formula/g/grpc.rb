class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.58.1",
      revision: "0f8cb206ef897f9cff2206e06a1a5303dbd4aeef"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple major/minor versions and the "latest"
  # release may be for an older version, so we have to check multiple releases
  # to identify the highest version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "87d5310847d31f59c6219620b5af420c74665c10d5af6ce3d35d7ffbfba93026"
    sha256 cellar: :any,                 arm64_ventura:  "11528e09facf1657db7bae06e86b50a81948348524da90256a6c7062321fac19"
    sha256 cellar: :any,                 arm64_monterey: "5b9a019375a28087db517d35fd76d49c25c8f5427722f862f97001be32f3d81e"
    sha256 cellar: :any,                 arm64_big_sur:  "81750aa9bc2abd9356483e3735bfdeb3fd4e53a9a52b6281a65f524a2f56e65e"
    sha256 cellar: :any,                 sonoma:         "91d75ccac1bbb9501e0c16d1f432a8170e669a581916e11d98f3d3c27e1e803a"
    sha256 cellar: :any,                 ventura:        "e7cdd90085c071486ca409dfb9a3359f91e44cd6176d586ddcb59a0ddc674e86"
    sha256 cellar: :any,                 monterey:       "26360ef3a63e41ac32e01d9732f6ae28ff4048b10eec65943e23987895c4b519"
    sha256 cellar: :any,                 big_sur:        "cee4aafd811a3a1a8f63a8defa89e892af3b53622b616afff0941366902f6239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41806942bdcb3c80ce18c08d88be648197f1e977ef1e3b7744e497800fe57c72"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :test
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause "Requires C++17 features not yet implemented"
  end

  fails_with gcc: "5" # C++17

  # Fix `find_dependency` call in gRPCConfig.cmake
  # https://github.com/grpc/grpc/pull/33361
  patch do
    url "https://github.com/grpc/grpc/commit/117dc80eb43021dd5619023ef6d02d0d6ec7ae7a.patch?full_index=1"
    sha256 "826896efc97e6c3bd3c38fc5e09642db4c6c4ec54597624ee8905da89e1ba7b6"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)
    mkdir "cmake/build" do
      args = %W[
        ../..
        -DCMAKE_CXX_STANDARD=17
        -DCMAKE_CXX_STANDARD_REQUIRED=TRUE
        -DCMAKE_INSTALL_RPATH=#{rpath}
        -DBUILD_SHARED_LIBS=ON
        -DgRPC_BUILD_TESTS=OFF
        -DgRPC_INSTALL=ON
        -DgRPC_ABSL_PROVIDER=package
        -DgRPC_CARES_PROVIDER=package
        -DgRPC_PROTOBUF_PROVIDER=package
        -DgRPC_SSL_PROVIDER=package
        -DgRPC_ZLIB_PROVIDER=package
        -DgRPC_RE2_PROVIDER=package
      ] + std_cmake_args

      system "cmake", *args
      system "make", "install"

      args = %W[
        ../..
        -DCMAKE_INSTALL_RPATH=#{rpath}
        -DBUILD_SHARED_LIBS=ON
        -DgRPC_BUILD_TESTS=ON
      ] + std_cmake_args
      system "cmake", *args
      system "make", "grpc_cli"
      bin.install "grpc_cli"
      lib.install Dir[shared_library("libgrpc++_test_config", "*")]

      if OS.mac?
        # These are installed manually, so need to be relocated manually as well
        MachO::Tools.add_rpath(bin/"grpc_cli", rpath)
        MachO::Tools.add_rpath(lib/shared_library("libgrpc++_test_config"), rpath)
      end
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <grpc/grpc.h>
      int main() {
        grpc_init();
        grpc_shutdown();
        return GRPC_STATUS_OK;
      }
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@3"].opt_lib/"pkgconfig"
    pkg_config_flags = shell_output("pkg-config --cflags --libs libcares protobuf re2 grpc++").chomp.split
    system ENV.cc, "test.cpp", "-L#{Formula["abseil"].opt_lib}", *pkg_config_flags, "-o", "test"
    system "./test"

    output = shell_output("#{bin}/grpc_cli ls localhost:#{free_port} 2>&1", 1)
    assert_match "Received an error when querying services endpoint.", output
  end
end
