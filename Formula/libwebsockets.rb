class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets.git",
      tag:      "v4.2.0",
      revision: "1367c11e1ee44d9e19daa50e1d015365bae17354"
  license "MIT"
  head "https://github.com/warmcat/libwebsockets.git"

  livecheck do
    url "https://github.com/warmcat/libwebsockets"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "b3ecadf2d9037e74bc8636cf8003ca1bf4e6d0ecb0ae876b6744187eee72c0da"
    sha256 big_sur:       "82ece83f10bd81b09a75b26d9fac42e9f47b0bc5aba2fb8f8c8b7a9e71060e36"
    sha256 catalina:      "70b4d1619b5e14c805344c4657cd027e2ed66f40c2ee96d44894f826bf016042"
    sha256 mojave:        "9ad37c1076e538987ca0ba85e9e89d88bf36bd51abf547f0f15084f8641b9ecf"
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
