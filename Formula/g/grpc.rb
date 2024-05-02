class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc.git", branch: "master"

  stable do
    url "https://github.com/grpc/grpc.git",
        tag:      "v1.62.2",
        revision: "96f984744fe728e196c11d33b91b022566c0d40f"

    # Backport fix for Protobuf 26
    patch do
      url "https://github.com/grpc/grpc/commit/98a96c5068da14ed29d70ca23818b5f408a2e7b4.patch?full_index=1"
      sha256 "5c4fc4307d0943ce3c9a07921bddaa24ca3d504adf38c9b0f071e23327661ac1"
    end
  end

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
    sha256 cellar: :any,                 arm64_sonoma:   "1703b2ac056024117f170d58d21b9b650073a02a1e0eb19e255385ab6c3b2989"
    sha256 cellar: :any,                 arm64_ventura:  "59e73c2550a48bc41011362abca358d1bc5b4e9f3ebb89dbe5a60b3affc5e440"
    sha256 cellar: :any,                 arm64_monterey: "5989d4001eca8e266e356f3c1fd09e86f99fd5d8d736ec21ef7bd4a974e81008"
    sha256 cellar: :any,                 sonoma:         "0b6cba081b15a6bf376f2c11e9b7b76914eec012a008b109a378ce825f75032d"
    sha256 cellar: :any,                 ventura:        "76a6e47a7f9daff701e99fbbe6122a42828da91319a66c33ffb19f6d493b9453"
    sha256 cellar: :any,                 monterey:       "83f567b98382ee7926a0f5dc13bbf0d4acb6a9178c5c6401731747329f64d65c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0285573515a136f5725811578cdde61da6de29d319a9d2d5b83da930a207cd5f"
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

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)
    args = %W[
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
    ]
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    # The following are installed manually, so need to use CMAKE_*_LINKER_FLAGS
    args = %W[
      -DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}
      -DCMAKE_SHARED_LINKER_FLAGS=-Wl,-rpath,#{rpath}
      -DBUILD_SHARED_LIBS=ON
      -DgRPC_BUILD_TESTS=ON
    ]
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build", "--target", "grpc_cli"
    bin.install "_build/grpc_cli"
    lib.install Dir["_build/#{shared_library("libgrpc++_test_config", "*")}"]
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
