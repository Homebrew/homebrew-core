class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v3.2.0.tar.gz"
  sha256 "5e731c536a20d9c03ae611631db073f05cd77bf0906a8c30d2a13638d4c8c667"
  revision 1
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "3196125ae013d45631b5f28fc60df1545357f98b94b3c45742e177554bec3b9f" => :mojave
    sha256 "6195a152caa89229651dd1a0834283754ebad277d06755e8b851a0d0471cde61" => :high_sierra
    sha256 "ff664e498d2cc5d17663d5990d4100c05de251fbb65e5a22ae1209241cb8d3f6" => :sierra
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
