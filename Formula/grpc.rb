class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.56.0",
      revision: "6e85620c7e258df79666a4743f862f2f82701c2d"
  license "Apache-2.0"
  revision 2
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
    sha256 cellar: :any,                 arm64_ventura:  "92e1da8bc605adee4e1057719b69984dfd81dbfc64317ecfe0d366c54218b8ad"
    sha256 cellar: :any,                 arm64_monterey: "0f88f8cea5988e71ceb987ad3b658774d45bcb383bf809163cca3a87f13eefed"
    sha256 cellar: :any,                 arm64_big_sur:  "0ee770b285f3d576e89a151944da948ab92db662832b20751ef43a2479109c9b"
    sha256 cellar: :any,                 ventura:        "326b5ca1baa7572ce0095939ff8f55fed3e2e2a199040d4a62a928a5ec161db4"
    sha256 cellar: :any,                 monterey:       "2d7161a6f50b4dc4671e85ab128f97b48d49079c2e0a19b1450cb4836d861f0a"
    sha256 cellar: :any,                 big_sur:        "d6e892096406f8080efc8c36af37bbe021eb93b4aa019bb0e55682edd9f2f12d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55f5a4e1a23f8a0f4ebd4a7f251d8789ca6fadc0e34cfdf7b541756771198562"
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
