class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://github.com/warmcat/libwebsockets"
  url "https://github.com/warmcat/libwebsockets/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "53110bb179448c6d589f669afcc42141085c579bcba8cd6dc09bc93825a18d26"
  license "MIT"
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4eb1926ebff006af4ace1c21fb7fdff65a42ff01b9499ddbb61ca73c9eacf56a"
    sha256 arm64_sequoia: "6429af6f6ea6886efdabe6d140fbd89141c360fc98726dbc8ae5992aadff8e15"
    sha256 arm64_sonoma:  "66748bfa039a3f81b57bcaf56a85fb29e8d6656487448dd0eadf999e6d10b8a4"
    sha256 sonoma:        "c2f1bd415508da200698bddec2449c234275c9d2b85343cc1bbf45ba106533f0"
    sha256 arm64_linux:   "a6bbd2c6ffec3d292b434a3830102c32ac2898a855fd9beb08f1b0beeb4f3b0a"
    sha256 x86_64_linux:  "fcfcc6716af27567fe7b994d0f5019512503736e08736d577d52ddce4163eee7"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"

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
