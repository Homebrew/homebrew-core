class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v2.3.0.tar.gz"
  sha256 "f08a8233ca1837640b72b1790cce741ce4b0feaaa6b408fe28a303cbf0408fa1"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "92afdc6af30cead64eaae3d255cc84b487ca0a2722ada4d3fc9897bb6121aa17" => :high_sierra
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
    system ENV.cc, "test.c", "-I#{Formula["openssl"].opt_prefix}/include", "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
