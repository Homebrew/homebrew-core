class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v2.4.0.tar.gz"
  sha256 "0dc355c1f9a660b98667cc616fa4c4fe08dacdaeff2d5cc9f74e49e9d4af2d95"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "fa988289adfd28f985f9b80919175fa7e10b07b4e347e4051417ab1dff7f34fe" => :high_sierra
    sha256 "11151280809531c7de2719a2ffd84f9ddf8192b26e2dd3f262b989ffd9847f3d" => :sierra
    sha256 "95e9e71da69bf1bbe1bfd2885c5f86431b9fd97424b94b900cdf077f81bbbb8d" => :el_capitan
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
