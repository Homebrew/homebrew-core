class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v3.2.0.tar.gz"
  sha256 "5e731c536a20d9c03ae611631db073f05cd77bf0906a8c30d2a13638d4c8c667"
  revision 1
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "2e639eb0b83e37d2d8d7c4a6d5c37b26f47f2fa50d45e57160f0fccd2095ce4b" => :mojave
    sha256 "f8b0c35ad1cd5ee7d77e1185a1bdfbdea00946d250e339dd8197c15994cf098c" => :high_sierra
    sha256 "dbb9b8a08e135d86865fbbf94eb3e63beb123819924da431a68a239ae0a6c357" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DLWS_IPV6=ON",
                    "-DLWS_WITH_HTTP2=ON",
                    "-DLWS_WITH_LIBEVENT=ON",
                    "-DLWS_WITH_LIBUV=ON",
                    "-DLWS_WITH_PLUGINS=ON",
                    "-DLWS_WITHOUT_TESTAPPS=ON",
                    "-DLWS_UNIX_SOCK=ON"
    system "make"
    system "make", "install"
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
    system ENV.cc, "test.c", "-I#{Formula["openssl@1.1"].opt_prefix}/include", "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
