class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v2.4.1.tar.gz"
  sha256 "29414be4f79f6abc0e6aadccd09a4da0f0c431e3b5691f496acd081ae6a8240c"
  revision 1
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "784fbbb862e238fbd35b6794ca5a955f1709495fe1c5e6bda6167e5fd9df7476" => :high_sierra
    sha256 "9f11e8c8d02ee7887eee5bf1651c97fa8c2f743a33c8389056a8094785c17fcf" => :sierra
    sha256 "e371ad39c9f31411339e1c55826e822f67726f63f27389562b53552f5f107f98" => :el_capitan
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
