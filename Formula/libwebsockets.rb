class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v3.1.0.tar.gz"
  sha256 "db948be74c78fc13f1f1a55e76707d7baae3a1c8f62b625f639e8f2736298324"
  revision 1
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "b2365f8b06d0b2909fb3877afb76e19728566fb375ea683bd1bc10cac2eadbb4" => :mojave
    sha256 "f460e7d8d0468d0323a11e2f6710c4a7f194f2f021265e6b09f653b14cbe9177" => :high_sierra
    sha256 "aa23d5b1e57d773d79c0e8681947cb4f2025cf3f14310a42fe40d82825bb652e" => :sierra
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
