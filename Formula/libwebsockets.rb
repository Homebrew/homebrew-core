class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v4.0.13.tar.gz"
  sha256 "fb73e26868daeb819e0c1f73a8f50eb2fa0b5c1fc1811a87a2b7dc77479ae291"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "4ae831d568f8f1aa9f8bfe1310effdb495e7e6be2b2a7411da7007e5bd470179" => :catalina
    sha256 "c5a57112ec5d73630fdab62f261ba1861227d1a28c71060aab134f8c9ad43571" => :mojave
    sha256 "8dabeb5415cac60b71f1817688ee608b778879b8b6fc8e03c6448e8954b9706f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

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
    system ENV.cc, "test.c", "-I#{Formula["openssl@1.1"].opt_prefix}/include",
                   "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
