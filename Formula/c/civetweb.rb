class Civetweb < Formula
  desc "C/C++ embeddable web server with optional CGI, SSL and Lua support"
  homepage "https://github.com/civetweb/civetweb"
  url "https://github.com/civetweb/civetweb/archive/refs/tags/v1.16.tar.gz"
  sha256 "f0e471c1bf4e7804a6cfb41ea9d13e7d623b2bcc7bc1e2a4dd54951a24d60285"
  license "MIT"
  revision 1
  head "https://github.com/civetweb/civetweb.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "024d02e19a39eef52b853e38e13edc39eafe8e0585abb6c8d8931ec75d28618b"
    sha256 cellar: :any, arm64_tahoe:       "88c28b02f684f70e0d8470a38a66e61f25cbe08efbf0fe66dfc39cef93cf029b"
    sha256 cellar: :any, arm64_sequoia:     "d04577184b0a9cfa245de4b96ae76734a97a4ab44ee04a21b8d04b17b3944dc1"
    sha256 cellar: :any, arm64_linux:       "4126eb10798b8492e6ecbd52372c613e869308840634e8a1f0a6d359eecdb0be"
    sha256 cellar: :any, x86_64_linux:      "dff4aa9a7567a9ca4c5dcb3c57b22678ca8fa7a790194cf81ba6d52df630807f"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCIVETWEB_BUILD_TESTING=FALSE
      -DCIVETWEB_ENABLE_ASAN=OFF
      -DCIVETWEB_ENABLE_CXX=ON
      -DCIVETWEB_ENABLE_SSL=ON
      -DCIVETWEB_ENABLE_SSL_DYNAMIC_LOADING=OFF
      -DCIVETWEB_ENABLE_WEBSOCKETS=ON
      -DCIVETWEB_ENABLE_X_DOM_SOCKET=ON
      -DCIVETWEB_ENABLE_ZLIB=ON
      -DCIVETWEB_SSL_OPENSSL_API_3_0=ON
      -DCIVETWEB_SSL_OPENSSL_API_1_1=OFF
      -DCIVETWEB_SSL_OPENSSL_API_1_0=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=TRUE
    ]
    odie "Remove CMake 4 workaround and -DUSE_X_DOM_SOCKET!" if version > "1.16"
    # https://code.opensuse.org/package/civetweb/blob/master/f/civetweb.spec#_80
    # CMake version fix: https://github.com/civetweb/civetweb/pull/1306/changes
    args += %w[
      -DCMAKE_C_FLAGS=-DUSE_X_DOM_SOCKET
      -DCMAKE_CXX_FLAGS=-DUSE_X_DOM_SOCKET
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]
    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "civetweb.h"
      int main() {
          printf("%d", mg_check_feature(0xFFF));
          return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lcivetweb", "-o", "test"
    assert_match "2719", shell_output("./test")
  end
end
