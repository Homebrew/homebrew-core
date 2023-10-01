class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://github.com/warmcat/libwebsockets"
  url "https://github.com/warmcat/libwebsockets/archive/v4.3.2.tar.gz"
  sha256 "6a85a1bccf25acc7e8e5383e4934c9b32a102880d1e4c37c70b27ae2a42406e1"
  license "MIT"
  revision 1
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d2e0e43c2c8e9d0bf5d85c2fa78b2d416c48eef28654f03d1943e2d6a1bf98b7"
    sha256 arm64_ventura:  "81cf501100ed76a29b295272b3e924a49bc165bfe75c57548544e44a56fbdeaf"
    sha256 arm64_monterey: "2af07ac1e2c5e1e9ef2a99addeffa8815d522fac6080d69e7b886e20eb82569b"
    sha256 arm64_big_sur:  "ac161d45763d1348e6987c4360f36cee290d20a908bd4527a02092d08c4cd447"
    sha256 sonoma:         "f36813d666799f73f725007b67cc4dd9d5bf597e23b0586b0b29eec7f26248e8"
    sha256 ventura:        "5aa9a2a8394067e7e3f125356b0d5c010bb345d98623e1984ed0c6ce4bf7c28a"
    sha256 monterey:       "cc1b7ce4c7b301e90c38683cdfea2df90eb67f91b123b736c688f9b91ce134b9"
    sha256 big_sur:        "7a5db0cadfc2cd020e6238b17ff65caff1a0fce2b00137c72b8da9b6b8d6c892"
    sha256 x86_64_linux:   "98f202eb1c6a27a250dd49f3063a3607ddaea763b75f6c66fc966dfde42063ad"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"

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
    system ENV.cc, "test.c", "-I#{Formula["openssl@3"].opt_prefix}/include",
                   "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
