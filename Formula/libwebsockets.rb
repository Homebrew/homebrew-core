class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v3.1.0.tar.gz"
  sha256 "db948be74c78fc13f1f1a55e76707d7baae3a1c8f62b625f639e8f2736298324"
  revision 1
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "c3dee13c27c98c87853ec9d1cbd3db27473c3fee1b0870260dc6c47294dd95e4" => :mojave
    sha256 "fce83552c866222ad1386145cdd9745b82efc0c0a97b89b9069b98928241e893" => :high_sierra
    sha256 "a57218f16bde1f484648fd7893d99d3dafc5c0ade4902c7ce442019b9782dc66" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl"

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
    system ENV.cc, "test.c", "-I#{Formula["openssl"].opt_prefix}/include", "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
