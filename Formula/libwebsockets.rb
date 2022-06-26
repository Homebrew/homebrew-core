class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v4.3.2.tar.gz"
  sha256 "6a85a1bccf25acc7e8e5383e4934c9b32a102880d1e4c37c70b27ae2a42406e1"
  license "MIT"
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "484f90dcde64c3605df5b2fc2fd9faef171085d743b4d1520b09728ca85cf662"
    sha256 arm64_big_sur:  "1727bec23d5018df72990a06198f2c707a1194eb0c37f2feac31f669a214f362"
    sha256 monterey:       "4cc0e4d50fa1e748b3ad856e107922a4126ee2cebb40027e973a5e909260b0d9"
    sha256 big_sur:        "b3b38523f111b97cf429a6ff71d6af3ddb7bc593a01beeef9651b1fd847ecd01"
    sha256 catalina:       "1ccabb4e27d6f00fbbc5bbbdfcb0ec2c752c603ac0824f454572c240d2ef2773"
    sha256 x86_64_linux:   "a8a1741ca831b3ae9f8aafc7c05b67339f66f3e0a7ae576dc70944263c555aef"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLWS_IPV6=ON",
                    "-DLWS_WITH_HTTP2=ON",
                    "-DLWS_WITH_LIBEVENT=ON",
                    "-DLWS_WITH_LIBUV=ON",
                    "-DLWS_WITH_PLUGINS=ON",
                    "-DLWS_WITHOUT_TESTAPPS=ON",
                    "-DLWS_UNIX_SOCK=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <openssl/ssl.h>
      #include <libwebsockets.h>

      int main()
      {
        struct lws_context_creation_info info;
        memset(&info, 0, sizeof(info));
        struct lws_context *context;
        context = lws_create_context(&info);
        lws_context_destroy(context);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["openssl@1.1"].opt_prefix}/include",
                   "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
