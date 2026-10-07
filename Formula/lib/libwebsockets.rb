class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://github.com/warmcat/libwebsockets"
  url "https://github.com/warmcat/libwebsockets/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "f853c6582101cfcee3a5a9e28ae92ab19d9735c5f31f0bb2e9794b5106123962"
  license "MIT"
  revision 2
  compatibility_version 6
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "0743d8cd08cd9d81c95fa1392cf9b7de6c5c52d652cbf00d1df004751ae9a183"
    sha256 arm64_tahoe:       "97370dc398d491a188f2f303ec1aab1bd2576f981e2ca6cc42e95374667e6330"
    sha256 arm64_sequoia:     "910fc3061663c7e2c8dc33af9d99e9df76dca95f0bba5a368306f955c94d6b92"
    sha256 arm64_linux:       "80c2075b90f66410f0247671b58ec18ae95e33450780b5aa15966a84e49109cb"
    sha256 x86_64_linux:      "84b53118fc440aeb02f47aa8dbc5bd9a08112ce6e00a6a75a324c12c3257f7e4"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@4"

  deny_network_access!

  def install
    # HTTP/3 forces the GnuTLS backend from 5.0.0 onwards, which ttyd cannot build against.
    system "cmake", "-S", ".", "-B", "build",
                    "-DLWS_IPV6=ON",
                    "-DLWS_WITH_HTTP2=ON",
                    "-DLWS_WITH_HTTP3=OFF",
                    "-DLWS_WITH_LIBEVENT=ON",
                    "-DLWS_WITH_LIBUV=ON",
                    "-DLWS_WITHOUT_TESTAPPS=ON",
                    "-DLWS_UNIX_SOCK=ON",
                    "-DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@4")}",
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
    system ENV.cc, "test.c", "-I#{formula_opt_prefix("openssl@4")}/include",
                   "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
