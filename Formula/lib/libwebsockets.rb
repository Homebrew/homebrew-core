class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://github.com/warmcat/libwebsockets"
  url "https://github.com/warmcat/libwebsockets/archive/refs/tags/v4.3.3.tar.gz"
  sha256 "6fd33527b410a37ebc91bb64ca51bdabab12b076bc99d153d7c5dd405e4bdf90"
  license "MIT"
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia:  "62d77884d8a09ddd1d79f74aa1a82103c85953c2b90ee08299a5343ca1d8833c"
    sha256 arm64_sonoma:   "72f689227f1633f1b5e71cf03c85375ec946fd88de6f11a5f9801e7b141a869e"
    sha256 arm64_ventura:  "577e551d2c2546b15a06ea63da365f64f9498d8087556b92bd2bf6571e198a8e"
    sha256 arm64_monterey: "da25e134a7c8bf8d9c9c87f4cc6c264fc1f387bd7f8518735c07d337c6890fae"
    sha256 sonoma:         "cef5f2e6af340223c19a5e59ee1469a8f5ffb677a7dce8201b23b554ff08bf1d"
    sha256 ventura:        "ad87e6e2c204feb0b8cd809660c0febaca9d7fc69e14dc095fe587960af13b9d"
    sha256 monterey:       "684e36d44f18efccb524ad8202740e465ece1a24e5d654954434c1caa0ccdb58"
    sha256 x86_64_linux:   "e8cbe679ed2c4a909afd481b3de3c779669b91fe4f57ee0cdd6c9614a9b02e58"
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
    system ENV.cc, "test.c", "-I#{Formula["openssl@3"].opt_prefix}/include",
                   "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
