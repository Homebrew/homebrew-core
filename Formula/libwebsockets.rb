class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  revision 2
  head "https://github.com/warmcat/libwebsockets.git"

  stable do
    url "https://github.com/warmcat/libwebsockets/archive/v2.4.2.tar.gz"
    sha256 "73012d7fcf428dedccc816e83a63a01462e27819d5537b8e0d0c7264bfacfad6"

    # Fix compatibility with libuv 1.21.0.
    # Not in the 3.0.0 release but should be safe to remove on >= 3.0.1.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/4d337833/libwebsockets/libwebsockets_libuv_1.21.0_compat.diff"
      sha256 "d2ef574b7c356573fc4ade2b95f7717e1eac192d8e56748b03588c89b12fdabd"
    end
  end

  bottle do
    cellar :any
    sha256 "420509f7b0e0fa39784b097d74c1d03a3ef1497cca3969b9090011c09e14d3a9" => :mojave
    sha256 "3f33d8419f44d82d4e926d35a13411991593708495d01bb3a7a6cdfcf7557f32" => :high_sierra
    sha256 "4e57715db563c9b82a013f9c1adec77a7fb1801c2dc5c696c5269438447cbc9e" => :sierra
    sha256 "9b031e7948664364f4ab3f31991bcd8d3f528f8c5f5d7ebda9a17b2f344497c7" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DLWS_IPV6=ON",
                    "-DLWS_WITH_HTTP2=ON",
                    "-DLWS_WITH_LIBEV=ON",
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
