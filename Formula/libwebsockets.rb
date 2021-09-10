class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets.git",
      tag:      "v4.2.2",
      revision: "8d605f0649ed1ab6d27a443c7688598ea21fdb75"
  license "MIT"
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url "https://github.com/warmcat/libwebsockets"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "fd821126fec58ef90a5409c6354fecc9819ccf13d52a88c061e607405ba98b2c"
    sha256 big_sur:       "2b0b926c4236961cf4adeb52cc3a606003e03db50d1337f127e255cd5aa72f58"
    sha256 catalina:      "c052c60d078806ef7e588d1a8bf32515636a44c6654a02f2652bbe8daec78951"
    sha256 mojave:        "65001a55abbef57c74da7c3785ac9b09cef97f2c66c861a16349ea88d9961363"
    sha256 x86_64_linux:  "ade28daa234d85448e6e1aaeca291c52100920249f33b5611e833825ec033f38"
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
