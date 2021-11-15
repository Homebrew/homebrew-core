class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets.git",
      tag:      "v4.3.0",
      revision: "a5aae049b2a386712e1be3b417915c0d44c7e675"
  license "MIT"
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url "https://github.com/warmcat/libwebsockets"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "f3caf45db7a61695308ccaf2c9fcf7a386c13d954047d3a081de00479ff9f263"
    sha256 arm64_big_sur:  "af413d5545311ce74f82ccf9a7c2051a38886ff3bee18cf2175365fb6dd67707"
    sha256 monterey:       "58b0eb117a33e2d28d423cff6576a63f2c21fdafdfc7b5b50eacb300fd537c31"
    sha256 big_sur:        "12a436faa6ab3e6b74477b00827d5b3e9c7d2cbe485ce17990f68ba84ff96e83"
    sha256 catalina:       "44b76ef2c664dfaff1a54d112ae641d5104887eca5097cdb7c0c25f3144b0826"
    sha256 mojave:         "551b2d0a5e2f601e0605d6e7a4b16a01ef34d868a9af9e2b21065d6e91ca4a92"
    sha256 x86_64_linux:   "494db4928a4e15f8d96c66198bc0ff5dbcfc4a15b54a8a63d13eb4ea58d1cd7d"
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
