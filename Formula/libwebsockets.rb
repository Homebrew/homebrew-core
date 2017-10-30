class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v2.4.0.tar.gz"
  sha256 "0dc355c1f9a660b98667cc616fa4c4fe08dacdaeff2d5cc9f74e49e9d4af2d95"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "7fe2c4a9fa645f4a8b26a3a7eefd730960da298125eb17d1e72bacd746fb27cc" => :high_sierra
    sha256 "68bc855036da875a6fcccff01fcca369e12f119378a6a1106005bab20d5201e9" => :sierra
    sha256 "6b372add72dbeae966daf5c8e476a9af87e9afae049173c6220942983a23e841" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
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
    system ENV.cc, "test.c", "-I#{Formula["openssl"].opt_prefix}/include", "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
