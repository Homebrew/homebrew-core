class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v4.0.20.tar.gz"
  sha256 "a26d243f2642a9b810e7d91f1e66b149d1da978decdca58ce1c9218c454f397e"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "1c58b7f6e0fc788ec6bdbf1be8465b5ea66c3ac5aaa35f6994245b815e5c4324" => :catalina
    sha256 "9e8a31e00e850e38cd5f354f707caaae8d24aac3034ae3f748192f9a47912157" => :mojave
    sha256 "72eded73851def11c00c25a96c0934c8b9d67c20d8f6e5915bb4ae0bd605c2a6" => :high_sierra
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
