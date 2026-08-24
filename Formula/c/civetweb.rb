class Civetweb < Formula
  desc "C/C++ embeddable web server with optional CGI, SSL and Lua support"
  homepage "https://github.com/civetweb/civetweb"
  url "https://github.com/civetweb/civetweb/archive/refs/tags/v1.16.tar.gz"
  sha256 "f0e471c1bf4e7804a6cfb41ea9d13e7d623b2bcc7bc1e2a4dd54951a24d60285"
  license "MIT"
  head "https://github.com/civetweb/civetweb.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "876584aeab2710cc49b81d1e5042d985c76bf633215a8e49bf452fb08ff0a83b"
    sha256 cellar: :any, arm64_sequoia: "616bb7606c68eedcd9bb644048334d73f49002a2a2a0080291a6ffd3f6eaada5"
    sha256 cellar: :any, arm64_sonoma:  "82ee0e5ed3bb59f1c246a2150f2d161ef9aecabd9b7ce4631127d1a0fe010efd"
    sha256 cellar: :any, sonoma:        "4a9835f3b88f3bf9b6a4eefacf318962f8953638bdd0d23ac75b270b0d23d931"
    sha256 cellar: :any, arm64_linux:   "36949610c5738876894445945c1f1f8ec5063c96819b8fa45d2bc5643160eac3"
    sha256 cellar: :any, x86_64_linux:  "78be4d06a6b2bd348f289b8cda144e29eca03f2fe9fe91b2d7634b16f700fc38"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
