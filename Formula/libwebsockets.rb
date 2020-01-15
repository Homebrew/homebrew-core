class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v3.2.1.tar.gz"
  sha256 "5b1521002771420bc91e1c91f36bc51f54bf4035c4bebde296dec235a45c33df"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "a4139f3dbecd0d44a5ca45cb87c37c3ec14f40d4e7d3fd538026705f4e4e9c1e" => :catalina
    sha256 "f852140a238a0cb15d5999aeb2109e7321787470148a962e7bf1139bd3f00d30" => :mojave
    sha256 "d4b41fe50985e4c96da62a17a63066ed337025dd6681046c1eb1dfb9104e803f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

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
    system ENV.cc, "test.c", "-I#{Formula["openssl@1.1"].opt_prefix}/include", "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
