class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
      tag:      "v1.85.4",
      revision: "ee6c934222c4ad96bbec18845c4d8e8762983189"
  license "Apache-2.0"
  compatibility_version 7
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
    manifest_sha256 "2acd3bd3381f4a4f3f678dc048dd069f96cfba797ed6cc4476cacfbc9df7cb68"
    sha256 cellar: :any, arm64_golden_gate: "df44b0f15bb309b2ad9c5424ca013dd3727ae267a0582e41ef179ec5d620abf6"
    sha256 cellar: :any, arm64_tahoe:       "6141ba420d79dd712f47d36ffaf7956bd393a0e5a7a4c580e9b32ecc44976d96"
    sha256 cellar: :any, arm64_sequoia:     "7b68aca788a3b86e12304a7ed453f9393fc7e90807a113ab2347dbe0d136528b"
    sha256               arm64_linux:       "d3621916dc88f8e626204149b626b2a37bf4be92031d98e1a13843dfb61ef070"
    sha256               x86_64_linux:      "bfe0582f8a7ac2e748855016c2a15b90aa7bcc9dc7c3837b25da7731007cfc61"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "openssl@4"
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

    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("zlib-ng-compat")/"pkgconfig" if OS.linux?
    flags = shell_output("pkgconf --cflags --libs libcares protobuf re2 grpc++").chomp.split
    system ENV.cc, "test.cpp", "-L#{formula_opt_lib("abseil")}", *flags, "-o", "test"
    system "./test"
  end
end
