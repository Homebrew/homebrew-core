class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://github.com/warmcat/libwebsockets"
  url "https://github.com/warmcat/libwebsockets/archive/refs/tags/v4.3.5.tar.gz"
  sha256 "87f99ad32803ed325fceac5327aae1f5c1b417d54ee61ad36cffc8df5f5ab276"
  license "MIT"
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "9e99f2685bfac3273ac873bedec5c4ce4514666bf717dc9318856810ab92f7d2"
    sha256 arm64_sonoma:  "8ea3a281fe5caf527100e46eeda10d31ac366839d846785da3c5b365f8882e75"
    sha256 arm64_ventura: "1fe9ee68992714b466b2cfe7dffe84f4e08fe10de909d44916b5155887f9e825"
    sha256 sonoma:        "aa41d5252a17883dbb24bf7f88a1246ba5f928fd6373983923fc74aec5f34198"
    sha256 ventura:       "7690e37818cd8b559f7fd44ef1380da6ade8830294899f2d02c513c446ac3f15"
    sha256 arm64_linux:   "543d812d4c12757637936ae3180496ce33254d92bfa4577f12fac418736f84c0"
    sha256 x86_64_linux:  "a5baeb55111964b22daeb1bcc9138d7835999ee92e836eaac24fb616859dc654"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
