class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v4.0.15.tar.gz"
  sha256 "adce8152c3e802b8fe71b26d7252944944c49954ba6b5ba9fbb7fa5c4aad93dc"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "fd425796e4caedb4c68cee8234090a12aac075e3b695b0f1664d1d4e83e2d976" => :catalina
    sha256 "b68ba896cb036b90b9cfec3f6a0d4065900560dca397213ad6e947c17f3b5222" => :mojave
    sha256 "a524010cb3b4a0030c8245c1ec1fcef5f10d5704b44e9a22ea9703ed70bc8c17" => :high_sierra
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
