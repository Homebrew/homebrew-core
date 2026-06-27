class Civetweb < Formula
  desc "C/C++ embeddable web server with optional CGI, SSL and Lua support"
  homepage "https://github.com/civetweb/civetweb"
  url "https://github.com/civetweb/civetweb/archive/refs/tags/v1.16.tar.gz"
  sha256 "f0e471c1bf4e7804a6cfb41ea9d13e7d623b2bcc7bc1e2a4dd54951a24d60285"
  license "MIT"
  head "https://github.com/civetweb/civetweb.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "84500077ecbf937f27bd340255df08f85c611bb6e279aabdf0494b8f403d1705"
    sha256 cellar: :any, arm64_sequoia: "599e77fc8ecf92a209361e3e7b8e4cf77acd9407ccc19f4b27ee1ab59c898e9e"
    sha256 cellar: :any, arm64_sonoma:  "584ae3c376e86eec69b69db14c7de84c0484ad08d600a5b15e607fb7e86b97cf"
    sha256 cellar: :any, sonoma:        "e147e0b2f0b2e6830a6d7adc40ee9c72d84383c9ab17a9fbf35583d1130c2044"
    sha256 cellar: :any, arm64_linux:   "10d8f136bc162fb5df313079862e0b5613927fb9a5e3c492596178513dc0d122"
    sha256 cellar: :any, x86_64_linux:  "e1c23209f912eab140488c04eaf3f4cb575727cc7f7eae5f32b3cdcc85a69c93"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
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
