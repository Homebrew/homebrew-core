class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v2.4.2.tar.gz"
  sha256 "73012d7fcf428dedccc816e83a63a01462e27819d5537b8e0d0c7264bfacfad6"
  revision 1
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    cellar :any
    sha256 "adb184c4f9e101b0bbe6ca427bc7e88fb398c30760127d18d7359f3fc33f5192" => :high_sierra
    sha256 "b56a98135edd29ef5781632b8a981338ee5fb519f07d8e6405857ade1c0352da" => :sierra
    sha256 "ab04ae62464bdae39c599a18afcd18b4d570c6a833cbc8fb2be20a3a45d39ce6" => :el_capitan
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
