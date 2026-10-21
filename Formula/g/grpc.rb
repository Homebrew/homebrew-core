class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  license "Apache-2.0"
  revision 2
  compatibility_version 6
  head "https://github.com/grpc/grpc.git", branch: "master"

  stable do
    url "https://github.com/grpc/grpc.git",
        tag:      "v1.84.0",
        revision: "3252a89f10d8e92997862167ca7d095ecda85973"

    # Backport support for OpenSSL 4
    patch do
      url "https://github.com/grpc/grpc/commit/fb056ab0bb3ed003febe82f069ff41514288a4f3.patch?full_index=1"
      sha256 "87b230d855ec21fe0a58d6a1d1c726c1a78ccd2cbda6269998f5177f12f10bb4"
      type :backport
      resolves "https://github.com/grpc/grpc/pull/41932"
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
    sha256 cellar: :any, arm64_golden_gate: "e88aa2947bc6b57b425d8def81a279cf0410b2ded2ef460d067b7464a7e1d440"
    sha256 cellar: :any, arm64_tahoe:       "37a199b3dc245c275400f32fb80ee8638b5b7b04e849d65c21411756098a0d58"
    sha256 cellar: :any, arm64_sequoia:     "dc7bcc9876473c5dfe42ee56f9c3022f52bc99dc2ed21d62e69cdb19ba4ca53a"
    sha256               arm64_linux:       "0d53e5688769b0c2f58c9ec10c01f72ffb825d54ff7a3d546fcd763eb40058af"
    sha256               x86_64_linux:      "28aac1ab06797ccf316949d7768470adb536205b193ae337ae6ce7ad1aecf6e7"
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

    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("openssl@4")/"pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("zlib-ng-compat")/"pkgconfig" if OS.linux?
    flags = shell_output("pkgconf --cflags --libs libcares protobuf re2 grpc++").chomp.split
    system ENV.cc, "test.cpp", "-L#{formula_opt_lib("abseil")}", *flags, "-o", "test"
    system "./test"
  end
end
