class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://github.com/warmcat/libwebsockets"
  url "https://github.com/warmcat/libwebsockets/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "f853c6582101cfcee3a5a9e28ae92ab19d9735c5f31f0bb2e9794b5106123962"
  license "MIT"
  compatibility_version 6
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "40b60bda9bcf364bf97f2be5cc4aebb33ef6875b8d066901c1922edab2b2f9ad"
    sha256 arm64_sequoia: "0dfd541e9c92c8fc34d553e716d9323172b38d7ef84013aec7e080d6d5f2c07e"
    sha256 arm64_sonoma:  "0eb5268dabac072732b82fa7337c2a3cd16ee040e1bc6bc1bdaa896441518a00"
    sha256 sonoma:        "fa294c0cfaee7c634c72f2b9102cd15b54ee2b6de19e7982fc8e617555c31e14"
    sha256 arm64_linux:   "924c9a44f52a6ad16b40f376922687308c90cad4302d26e1a3ba2080736b9707"
    sha256 x86_64_linux:  "bb3c0a4b41d41a3b89c7ca9f6b77377a810d6910e48df5a13f4d3b079353443e"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"

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
    system ENV.cc, "test.c", "-I#{formula_opt_prefix("openssl@3")}/include",
                   "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
