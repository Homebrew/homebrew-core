class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.3.8.tar.gz"
  sha256 "b6943b564787c4953b77ca8d7f987c4b896b3f3e91f45d9f13e9056b6148bc1d"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4983d3fb3b6a27895ef3125b2c74a56c33c7f98b501cfc08dfa8a2e753e7236c"
    sha256 cellar: :any,                 arm64_ventura:  "fa1efbf122c451bb9ca6f9dd00549fcff1d0604e8d2077e74b56105e49f599f8"
    sha256 cellar: :any,                 arm64_monterey: "b41f5577435d317810bea1a1f9a9176f5daf32f506a09af1e6b29e532f3f95e9"
    sha256 cellar: :any,                 sonoma:         "19e58c7862e650a3a97204d3599b7ee0c3de5398b0edacf13c3ff706d5dcc506"
    sha256 cellar: :any,                 ventura:        "150ebde98e87dc8cde21c6fd10d92ce74b19d781957ed9e8b4bdabc0acb81ee9"
    sha256 cellar: :any,                 monterey:       "6f92d5e0e81659c8058206af01ac1419c181cb3390e9b621f31093f5dead13f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a30b1658d0fe9f7417c3ec9ede429a4919f1751b4cd1ef47217b2f6350f57f00"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    cmake_args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DUA_ENABLE_DISCOVERY=ON
      -DUA_ENABLE_HISTORIZING=ON
      -DUA_ENABLE_JSON_ENCODING=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <open62541/client_config_default.h>
      #include <assert.h>

      int main(void) {
        UA_Client *client = UA_Client_new();
        assert(client != NULL);
        return 0;
      }
    EOS
    system ENV.cc, "./test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lopen62541"
    system "./test"
  end
end
