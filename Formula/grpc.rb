class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.57.0",
      revision: "a61640173d00b63e0b55ad61915a9b1708e12d27"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc.git", branch: "master"

  # The "latest" release on GitHub is sometimes for an older major/minor and
  # there's sometimes a notable gap between when a version is tagged and
  # released, so we have to check the releases page instead.
  livecheck do
    url "https://github.com/grpc/grpc/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a1925decf9e4dbdc29a7e2481c0518fb895c8f484295dc58dc62f82f35543543"
    sha256 cellar: :any,                 arm64_monterey: "77e8fe074f70b74dabe201ecb8c57a6c3a89359a6a74ee5803efdc43ec439b8c"
    sha256 cellar: :any,                 arm64_big_sur:  "df67c20f184b86b6dea57b4746f4b09ac624796e370056364e81805ab42f646e"
    sha256 cellar: :any,                 ventura:        "b2353f81d470b64698eab7f1ff3e45dc64555e1eb166d8887d5f88419784a2d0"
    sha256 cellar: :any,                 monterey:       "d4fbcae60ced30a6c6e5ed49afbbfb11490567936a1fa1faf497bd21a31b6133"
    sha256 cellar: :any,                 big_sur:        "22e5a4282d21e70229cb17e6d4917492103452bc68dadf6232309d00d078cab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d7580deae881941493c27bc9128d7b9ea72c5fabb2cfad5c787aeeabc7e680a"
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
