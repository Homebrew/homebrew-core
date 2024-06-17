class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "4f45f33e4ebd5241142817c4c61a94f2b1353304c8adf9091562bafab6ddb3da"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6e373126577a9e3bbfcf9e0a8af0efd8a591f4de56a973030f34c1cf75ec8f00"
    sha256 cellar: :any,                 arm64_ventura:  "a7d1fc3e189216f34bc4dcfa452fde8f20dd30a0dda67b26f97df858d7159ce5"
    sha256 cellar: :any,                 arm64_monterey: "16149e9bae3065a3de45892464197f4d04095937498cdb80891a92e684f131ff"
    sha256 cellar: :any,                 sonoma:         "7ac7b7c0a40b9ccf3be75f6a2d7bdc54f9457d575c63681094e4b5c5918ec533"
    sha256 cellar: :any,                 ventura:        "cbd01a8b7eb1930d0b21adf6726ff7cea25c74e9eb55c27e905d6ee69feb1689"
    sha256 cellar: :any,                 monterey:       "cc5e4852a8039e1070d133447a7c7a1d5a4be2ebdea68a0f773efea879edd7fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d72b1a79865a4929af2cae353a600551c95b998f28b3ccfb24e2f7fb2c5f4cb"
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
