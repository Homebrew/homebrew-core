class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v4.0.20.tar.gz"
  sha256 "a26d243f2642a9b810e7d91f1e66b149d1da978decdca58ce1c9218c454f397e"
  license "MIT"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "671e40b52a25c5aabd5e3bfa9d1bacef8882870abf80ed531968b7bdc52ba7b6" => :catalina
    sha256 "ef189da41dcbed3bb8f358e0576c3a19bd559b54905271c07aeeddb5d7380410" => :mojave
    sha256 "bee063b0139fd076bfcaf68986713ad7593a1633582a1bec8348dd1e48142bb2" => :high_sierra
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
