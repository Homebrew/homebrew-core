class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://github.com/warmcat/libwebsockets"
  url "https://github.com/warmcat/libwebsockets/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "9acbba00aaa9e6178ae09c6f920d95449b527c1417e81d2cdd4103bc6d64d13f"
  license "MIT"
  compatibility_version 7
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "e74adf9d584a856321f9f296b4247274592c23c954a3168998c8f8bfc1932df1"
    sha256 arm64_tahoe:       "df4de90c24f08b522aebdd1b3925f15815b15dfa62150612244a1e48d4254cb4"
    sha256 arm64_sequoia:     "7d7fc8c203694dc167b40a796165369591e3efd20b0384f071d3210a6eb53221"
    sha256 arm64_linux:       "c4fad3ec1de3566338bf010684fad27cdb9554b2e9c5db82fe1dcaa8aa3afdc6"
    sha256 x86_64_linux:      "8628fddb347df584b5a31baa7c0395a2d7377fbdeb32a81dc923c642dbb8dfa5"
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
