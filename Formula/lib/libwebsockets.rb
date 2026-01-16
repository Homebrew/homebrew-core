class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://github.com/warmcat/libwebsockets"
  url "https://github.com/warmcat/libwebsockets/archive/refs/tags/v4.5.2.tar.gz"
  sha256 "04244efb7a6438c8c6bfc79b21214db5950f72c9cf57e980af57ca321aae87b2"
  license "MIT"
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "cc2560edbfebc0dca5c9981e9b60b790d7393f9d67d64cca14a70c9b81020ff2"
    sha256 arm64_sequoia: "293904c11a66fe605eeb07f52d4392a1a103003a29d3fc840ae2d4b31952b22e"
    sha256 arm64_sonoma:  "d240c2004fdbfc02e5d57821d01bcaf943f0ae747540a0d8e502200cfa906411"
    sha256 sonoma:        "5bfd9b7dcce167f85c69c21b76234a9ecdfa6646bf421693ebe80428127c8ec6"
    sha256 arm64_linux:   "a7590730928baf546d2622432d3cc528bc51865423c05b7eb6ab363cfeba3e39"
    sha256 x86_64_linux:  "305a4004dfe35c97a5feb707b50fdf2445efb7240fab48856c62aeac9d872fd5"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLWS_IPV6=ON",
                    "-DLWS_WITH_HTTP2=ON",
                    "-DLWS_WITH_LIBEVENT=ON",
                    "-DLWS_WITH_LIBUV=ON",
                    "-DLWS_WITH_PLUGINS=ON",
                    "-DLWS_WITHOUT_TESTAPPS=ON",
                    "-DLWS_UNIX_SOCK=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{Formula["openssl@3"].opt_prefix}/include",
                   "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
