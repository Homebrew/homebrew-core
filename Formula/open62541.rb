class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "65511f7268bf1a311296b21e5ebdef6e48edf04383518570117ed2a490a42855"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "50bd8ee76efb0497b5cf1e85f5b1d17a27c76779aad15d2457fe10a9c5deea72"
    sha256 cellar: :any,                 arm64_big_sur:  "7aec0d3112b68e0437bb80ec58495b8ae8cc2730b856fc7944561027e1b9ae98"
    sha256 cellar: :any,                 monterey:       "5934f68d7d8422904a46c3db83c743126c1ad7916c7ae27f44613b049676e793"
    sha256 cellar: :any,                 big_sur:        "d83ec9266ccd19c0276187a39b3f9e0493526b07dcf020f419e04943a3cf63a9"
    sha256 cellar: :any,                 catalina:       "c86de6fc572b8e1c3c7b9d5a71eb16efe07216d9beca0a8c60ac9214767b13be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28bf2cde54de317f66eb561f7f26bcabf16d5da874e26008fc28d03d0f05a8c4"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

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
