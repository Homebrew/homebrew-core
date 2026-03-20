class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://github.com/warmcat/libwebsockets"
  url "https://github.com/warmcat/libwebsockets/archive/refs/tags/v4.5.7.tar.gz"
  sha256 "d08df7634da0a377a4e077400ed6b2d1d25cf0b239e89397cd39432c5eb437ac"
  license "MIT"
  compatibility_version 4
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3135bd3239e950378923d8df6ec9c70a4222cd740a138c00b1defb9a2f98aaf0"
    sha256 arm64_sequoia: "6121702b0f3c6f7f0636547704f7345c468ff25b85b3372869e667a41777b479"
    sha256 arm64_sonoma:  "9ad132fe88a2bdb00016b58ad0ea2645f1477b3387f7ce82b406a8c841d06ed4"
    sha256 sonoma:        "01735300c2b1253864d85e13c68b277508aaf182472653162cc36f222c84e500"
    sha256 arm64_linux:   "8b2d26285f58ee9be0b666f56276ccbb683169a2b1a04a20922ccc516d513926"
    sha256 x86_64_linux:  "c6af478e72173205b324057a2b02b48c8b7349acc859015ac4948d7968b5fc84"
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
