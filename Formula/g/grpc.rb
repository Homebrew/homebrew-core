class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.83.0",
      revision: "c876f4da50f7da2f331888b88b2a7243514139fe"
  license "Apache-2.0"
  revision 3
  compatibility_version 5
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
    sha256               arm64_tahoe:   "69b48f4163d684037c946677df9898579170d77305e5b735dc0c3a7ef90f5afb"
    sha256               arm64_sequoia: "3e4091757d073253e8a2bc6f2e14dff60d7ca56b5503ba231f0094e7e8bb0dd8"
    sha256               arm64_sonoma:  "20324e9c27329c4e90935e04474dda04910b5bc393511264549a00f112fc39b2"
    sha256 cellar: :any, sonoma:        "98410ab86eb0ea8037677cc38cd40a54b411eda3f8a59fdbbc8ff52e072c103a"
    sha256               arm64_linux:   "e9fd521cb43ca6c5fe8748f619cd9acca84273e6c3ff619451883f2483564d7e"
    sha256               x86_64_linux:  "6168147cb202ea7ba1d91baa80ef762a0a2b0b9819c4aad61ed46539efbb7fa2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DBUILD_SHARED_LIBS=ON
      -DgRPC_INSTALL=ON
      -DgRPC_ABSL_PROVIDER=package
      -DgRPC_CARES_PROVIDER=package
      -DgRPC_PROTOBUF_PROVIDER=package
      -DgRPC_SSL_PROVIDER=package
      -DgRPC_ZLIB_PROVIDER=package
      -DgRPC_RE2_PROVIDER=package
    ]
    system "cmake", "-S", ".", "-B", "_build", "-DgRPC_BUILD_TESTS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <grpc/grpc.h>
      int main() {
        grpc_init();
        grpc_shutdown();
        return GRPC_STATUS_OK;
      }
    CPP

    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("openssl@3")/"pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("zlib-ng-compat")/"pkgconfig" if OS.linux?
    flags = shell_output("pkgconf --cflags --libs libcares protobuf re2 grpc++").chomp.split
    system ENV.cc, "test.cpp", "-L#{formula_opt_lib("abseil")}", *flags, "-o", "test"
    system "./test"
  end
end
