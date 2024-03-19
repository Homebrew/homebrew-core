class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.3.9.tar.gz"
  sha256 "71764d4a060cfa07eae7aaabd176da38b155ef01c63103513339699fd8026e2f"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8ae5132f5bb41de5b801e75882daa2223a72182c725beb8e8c0bd0f9b49b50cf"
    sha256 cellar: :any,                 arm64_ventura:  "98ee7bc2a1edc6fdce816081690ee4c1af2fb34556b82e2732723285b11d174c"
    sha256 cellar: :any,                 arm64_monterey: "d31cc67c2aee582b072cb4f791e35a16b92ef6491a11f4f318921a79e919f409"
    sha256 cellar: :any,                 sonoma:         "903330455ea1b917ec176c6c9a3823360fc697ad0e4e21227af99b75fc7d3de4"
    sha256 cellar: :any,                 ventura:        "9b19dab7a935239d230bf6bb961f5678e4a4fbd1566184b71e838f9525fe1966"
    sha256 cellar: :any,                 monterey:       "330e692184064cc81d52c5d4adf59c162fe55e7b82719310f4193bc33c9fc168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1da3e0b7501029723197bc8437235248ddcf0a81a7fd249f383811d7add7fa9c"
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
