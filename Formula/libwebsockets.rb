class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v2.2.0.tar.gz"
  sha256 "1be5d9b959eab118efb336ef07d6c1e0af08a17409f06167a55ae874221f11a1"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "3046a32a6afc92ba2c685d83d0da386141553c764574492c68f7a6ce3f3ec3f2" => :sierra
    sha256 "0c19c9087626c4f7e509163f53ead9937eeb371cdda552efad762e44b7e55c42" => :el_capitan
    sha256 "93a21679e75e32ca78fd6d0c3277ca489ef34813bb33809394ff5fec95329fc5" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
    system ENV.cc, "test.c", "-I#{Formula["openssl"].opt_prefix}/include", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
