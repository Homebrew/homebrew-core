class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v2.2.1.tar.gz"
  sha256 "e7f9eaef258e003c9ada0803a9a5636757a5bc0a58927858834fb38a87d18ad2"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "3a58aebfcd276a81557f21cf3cdcd1663868d9e3af2097fce16bee1b92eac9e4" => :sierra
    sha256 "1353fdacc6c88c5597bf158d6aba15287b7520354e79d46bc11b2994bac8369a" => :el_capitan
    sha256 "efba92b65603d249b4ebc7cbea8c705ae951e26fac7dcd9841af40bfbb3741f5" => :yosemite
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
