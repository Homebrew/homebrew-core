class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.83.0",
      revision: "c876f4da50f7da2f331888b88b2a7243514139fe"
  license "Apache-2.0"
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
    sha256 cellar: :any, arm64_tahoe:   "755aa5dd7133b6c40058d699892a098d38fa0dd02611048c84fe3f0da6efe044"
    sha256 cellar: :any, arm64_sequoia: "940816a5b7f08d05a47df5cb0666146ecde491e0e9cfca38b831cf84d3b67a59"
    sha256 cellar: :any, arm64_sonoma:  "4a82b9065b068793d799dfd556d4016c5acca3e563e80b2e9e6d86de8d0926e0"
    sha256 cellar: :any, sonoma:        "a58175efc010c05ced538846f5a49e48cf07b923e950ad43c668553471993a6b"
    sha256               arm64_linux:   "75e58cff1fc800e4f3858155e0c883f13b1a9d83fdf7dafd9fdfa050c9224570"
    sha256               x86_64_linux:  "634a6c4f8b0db77d889b266a88e6bb980e62459f5790d25a72ba657150b84920"
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
