class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.4.11.1.tar.gz"
  sha256 "2979c0f09b766fd6470bdf06c8500c90ed51327aae1c22af132641a44178b722"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bab00b791dd245527043b24a26b8ae566387fda5f8fc65fe5113184564576ea4"
    sha256 cellar: :any,                 arm64_sonoma:  "bc830bc0a7e51c72006cb7f7473fe9667b5fa8927abfc0e924137ebbdfa254d2"
    sha256 cellar: :any,                 arm64_ventura: "36dd694037fd7a1ec784f8f1028b1125e6f87094bf2a7fedd64449b06a7873ae"
    sha256 cellar: :any,                 sonoma:        "46bc477948bb7bffe96b79869908190d74573d14a041af11fb0971a6ac14ef06"
    sha256 cellar: :any,                 ventura:       "a71cf4c6c1cdfbcd06ad9bf6061be6555026665f7356e8552e03108137772d25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d875d5f061ac04c971c6fd921c8bde57bdff906ff5e93f810e3983f37a5a455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "974799a2dc8ee460e4053a40cd5d83ab72bb483e4ee90f48892150f80ecb1e39"
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
    (testpath/"test.c").write <<~C
      #include <open62541/client_config_default.h>
      #include <assert.h>

      int main(void) {
        UA_Client *client = UA_Client_new();
        assert(client != NULL);
        return 0;
      }
    C
    system ENV.cc, "./test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lopen62541"
    system "./test"
  end
end
