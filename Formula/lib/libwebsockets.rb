class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://github.com/warmcat/libwebsockets"
  url "https://github.com/warmcat/libwebsockets/archive/refs/tags/v4.5.8.tar.gz"
  sha256 "b6ade658f4af3a823d0dc806ae5ef0623f0f4f5e2aeb895a0f77c4783840c30e"
  license "MIT"
  compatibility_version 5
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4746b71efdac824a21e1e872ba70250419d744536a74883481b1544b0506fd10"
    sha256 arm64_sequoia: "acd80d40a6ab1175e1f6ab0b926c173d384cc069fbfa7e9e7ff7db1e41b41903"
    sha256 arm64_sonoma:  "fed6b0f38cbdd21756c7e2be4fe4762f7896bc83e8254ef64aba9677a2d20b3b"
    sha256 sonoma:        "122bd2962f1ac24e297e1bbd6309c6097366299c22413cd0f59be36f8c778705"
    sha256 arm64_linux:   "722d9af7020d79568d3c2d45bf64d1d486868b8481e001698c0d372af85d3d8c"
    sha256 x86_64_linux:  "9a6c6ca0b44531638b3b2c44c6002cbcf018a3a7a2d878891e9b83b3ab0ac03a"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLWS_IPV6=ON",
                    "-DLWS_WITH_HTTP2=ON",
                    "-DLWS_WITH_LIBEVENT=ON",
                    "-DLWS_WITH_LIBUV=ON",
                    "-DLWS_WITH_PLUGINS=ON",
                    "-DLWS_WITHOUT_TESTAPPS=ON",
                    "-DLWS_UNIX_SOCK=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{Formula["openssl@3"].opt_prefix}/include",
                   "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
