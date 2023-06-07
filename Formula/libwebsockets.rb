class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v4.3.2.tar.gz"
  sha256 "6a85a1bccf25acc7e8e5383e4934c9b32a102880d1e4c37c70b27ae2a42406e1"
  license "MIT"
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "3814285ea900c67fc77e8b8808a77c8686f64ac261c79dfa0a703fde6216fa48"
    sha256 arm64_monterey: "9e095deb6072f6406b90abc7d8e5690b4b85706263795c44acef5f9366bb0a6b"
    sha256 arm64_big_sur:  "6206862e2f249e7b97132755fe824ebe544ce43cb7eb128d4838026216734ed3"
    sha256 ventura:        "52a1341ff82000d608c47f09cf49b34b3b2b51d7833eda726ec51b807e8ce8d7"
    sha256 monterey:       "d8f82bb677e0f2b72608d58ff6c0569ed53c2de889a702487b3d96f75fb4c23e"
    sha256 big_sur:        "3d22604aac153f03a9b704b3e01e337724840ae1d99218221b48f87eeddea1fa"
    sha256 x86_64_linux:   "244a8643bdf87fb31af5936c755d2ca6f3b8b7f1c09376f3335fbfd5b66f7ef6"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

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
