class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v4.1.6.tar.gz"
  sha256 "402e9a8df553c9cd2aff5d7a9758e9e5285bf3070c82539082864633db3deb83"
  license "MIT"
  head "https://github.com/warmcat/libwebsockets.git"

  livecheck do
    url "https://github.com/warmcat/libwebsockets"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "df63df86c111e9167d3a418f957ccab9ba1ce2d640d6824be2ab88dc4de00205" => :big_sur
    sha256 "b9982b4bee7467522f5aa17ad1679378a7051a1b17196bb2f1efec44a1e89364" => :arm64_big_sur
    sha256 "52c228ffcf9c7cfcdc9f11474bdf644118b2f887209d13d5855d98a773331cab" => :catalina
    sha256 "6e1470908d767ad72e1a3cb7d9291a6f43906a46329b6b677f40f4932be06df4" => :mojave
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
