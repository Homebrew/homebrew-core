class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.51.1",
      revision: "0a82c02a9b817a53574994374dcff53f2e961df2"
  license "Apache-2.0"
  revision 1
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
    sha256 cellar: :any,                 arm64_ventura:  "ae834c08d68b254734cbc447444a7ed68c586bf54f7264a60fd9d5c84579b252"
    sha256 cellar: :any,                 arm64_monterey: "1608c7eedf66260356b7250d6a506f176e77cfa573adc8421fc95ceb3a4892d3"
    sha256 cellar: :any,                 arm64_big_sur:  "273400008e5051aa362e72c850d70b12b928a0122bf3b6e72a71d84865b7c39f"
    sha256 cellar: :any,                 ventura:        "546f1b138ecabede6d0ab9786e9ffb206c4b708f48101ebef41acc2301b79af5"
    sha256 cellar: :any,                 monterey:       "23fd418457a3c933128e182c4a7a507a9a174eaeaa523965504d105cf3df6fb8"
    sha256 cellar: :any,                 big_sur:        "2ab684061c5927a4f12fdba3ae5d1084b63169568989b6789a36637742120133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdaa72c6288d904047b2a1d7b0298e4687b896738d215a16ea761d292195f079"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :test
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "openssl@1.1"
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
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@1.1"].opt_lib/"pkgconfig"
    pkg_config_flags = shell_output("pkg-config --cflags --libs libcares protobuf re2 grpc++").chomp.split
    system ENV.cc, "test.cpp", "-L#{Formula["abseil"].opt_lib}", *pkg_config_flags, "-o", "test"
    system "./test"

    output = shell_output("grpc_cli ls localhost:#{free_port} 2>&1", 1)
    assert_match "Received an error when querying services endpoint.", output
  end
end
