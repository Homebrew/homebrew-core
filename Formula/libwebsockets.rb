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
    sha256 "5edd30eeb43f99680834d0cae61fde57077b51bfe6e811be304e8a8c1fd11617" => :big_sur
    sha256 "00debd0d684c9f178d4e43aadf3b3fb3ee45ff32084cea0b026b13bb007e2bd3" => :catalina
    sha256 "011f64fbfe3adf3efda20aa89deaeef93c9959e701496752b84ba190a0a6fede" => :mojave
    sha256 "8c98c0f71a20ee3a8066f0bbb8e28104a8e0e8a65dbdbb93c8311f7ca7f4b2cf" => :high_sierra
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
