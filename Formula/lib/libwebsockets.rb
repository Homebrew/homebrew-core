class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://github.com/warmcat/libwebsockets"
  url "https://github.com/warmcat/libwebsockets/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "472e6cfa77b6f80ff2cc176bc59f6cb2856df7e30e8f31afcbd1fc94ffd2f828"
  license "MIT"
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "adbf1ec53f5f714f712585230bf75174e101dd37d5d686a45c0f7bf73b20ffba"
    sha256 arm64_sequoia: "a965ebcaafd65f76997b7ba363fae823e4089d618f7f0e0719d84567e580f0cf"
    sha256 arm64_sonoma:  "48c33f1b7e2127ef3588f2ed4c7f1e16e7c4686820e5f4d90b301fc704fe68cf"
    sha256 arm64_ventura: "81b4a1cf2409e603b8e7ac69101aa5902d56e6b9aa61599ace0671a5449e5924"
    sha256 sonoma:        "403c3c806530d591e624efe2c43d47d866691924c91ce504778e33cfb3e4d225"
    sha256 ventura:       "1298fe6e7b79a02b4f46b5142d69c2a7bf5de7e1489684de289decdc6fea7c7e"
    sha256 arm64_linux:   "02496926fb45830667526c76a081b91947c56fccbd653c434ec91f29b3ac0734"
    sha256 x86_64_linux:  "1c9dcc51d83f208d195dea7723cace36d0365fbb686db4cce8863ebf3df7bb21"
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
