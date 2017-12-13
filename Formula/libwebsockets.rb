class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v2.4.1.tar.gz"
  sha256 "29414be4f79f6abc0e6aadccd09a4da0f0c431e3b5691f496acd081ae6a8240c"
  revision 1
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    cellar :any
    sha256 "05fa26269c3b2527e1290c750a77ef7e4a6cded2c242401590e6bfe12fbd0296" => :high_sierra
    sha256 "8b2c54f8b5adf33dedd8d437d49093dcca5875b72c4bad14d0c16a1013d506bc" => :sierra
    sha256 "9db109fd30d4719c198bde1569ced0f95ab2eea752127f5b88725765c84558bf" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libuv"
  depends_on "libevent"
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DLWS_IPV6=ON",
                    "-DLWS_WITH_HTTP2=ON",
                    "-DLWS_WITH_LIBEV=ON",
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
    system ENV.cc, "test.c", "-I#{Formula["openssl"].opt_prefix}/include", "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
