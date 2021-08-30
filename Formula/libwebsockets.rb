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
    sha256 arm64_big_sur: "ba717644e66fae9f240d95bcdd39e11ba957de37df8efef2b63569a8b36681f3"
    sha256 big_sur:       "3b344a740ca12f344419b9a60bbc334b4c56c862f90da9db94212a4a8a962ae4"
    sha256 catalina:      "0800c12bf4bc5c6578985abcc33cc39f799089f30fc49c0563e6c93b119ec1bf"
    sha256 mojave:        "8db90099d46e097a254ce612ba2531850e647ca925289f793a0307fc1520b66b"
    sha256 x86_64_linux:  "362765db8875a4962533bb2f0e327125bf885c3ae91381e9170857da77c42949"
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
