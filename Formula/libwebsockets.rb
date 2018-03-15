class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v2.4.2.tar.gz"
  sha256 "73012d7fcf428dedccc816e83a63a01462e27819d5537b8e0d0c7264bfacfad6"
  revision 1
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    cellar :any
    sha256 "98e839747183274970c3a62fcffe9f6e390405d488f5e7b3c57743f281cd512c" => :high_sierra
    sha256 "87878e4c44ba0dbf6608675f20afc1f0c272c2e8d4f61fbd6110a3130ad83a95" => :sierra
    sha256 "f4176df2b2d8cf9e23efa30f0e1dbbf8d3b7acd89b2f737272ed105626a9570f" => :el_capitan
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
