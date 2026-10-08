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
    sha256 arm64_golden_gate: "768cb2ce7842fff8985617533464c1e64f632fab59543953aaf5180a45155e41"
    sha256 arm64_tahoe:       "100fb7dd709a20adea80fc04fe9a2a1872ec0c6e3860b854192abe8602b7e809"
    sha256 arm64_sequoia:     "1b6ef78b93a5bc27f4d7f4ed3c992e4f9e8e31b8d091c45a47aa442c2971ba29"
    sha256 arm64_linux:       "db6fd512452137f98c625251314c8be70215ea846f0266e87a7956a8a2ea75f0"
    sha256 x86_64_linux:      "ebf54cc13c6a4e919f87401a25e0f0aad62ed7f8b7b6595af83681991e7b1914"
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
