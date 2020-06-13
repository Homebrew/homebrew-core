class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v4.0.16.tar.gz"
  sha256 "883cc0595656d712b331dd0607e05224b514fd1d24d64356cc4f50bfe3d9527b"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "572754ab8b5981b13b496cef56f222524a7d1daeced9b7d4515a6a128adc8e42" => :catalina
    sha256 "5d7da12767371c227933a29fe69104a361ce73055977da6cbaa5a967be040b6f" => :mojave
    sha256 "9d2b2e8a004142f21d73717a61e94d02f0147874f13094a8c7936cb55dea86da" => :high_sierra
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
