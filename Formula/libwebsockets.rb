class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v3.1.0.tar.gz"
  sha256 "db948be74c78fc13f1f1a55e76707d7baae3a1c8f62b625f639e8f2736298324"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    cellar :any
    sha256 "420509f7b0e0fa39784b097d74c1d03a3ef1497cca3969b9090011c09e14d3a9" => :mojave
    sha256 "3f33d8419f44d82d4e926d35a13411991593708495d01bb3a7a6cdfcf7557f32" => :high_sierra
    sha256 "4e57715db563c9b82a013f9c1adec77a7fb1801c2dc5c696c5269438447cbc9e" => :sierra
    sha256 "9b031e7948664364f4ab3f31991bcd8d3f528f8c5f5d7ebda9a17b2f344497c7" => :el_capitan
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
