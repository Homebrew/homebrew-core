class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.4.12.tar.gz"
  sha256 "4a551ca504d49fd4c87ebe64c82bcd51307d53c982ab5a9f23dbd902b18e9521"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0b1646b7c40cfa81afb5d8d698c485b7bda4f0d0ea85cbf3032fca0756bc737c"
    sha256 cellar: :any,                 arm64_sonoma:  "9e7713dc172579cdd8a37a4b4dcd375012d78bbf13619e6653ca2977c7800526"
    sha256 cellar: :any,                 arm64_ventura: "44206af81292c7b75535a9e7fc2636f8a70af5b818edec7078cd761ad83a0b21"
    sha256 cellar: :any,                 sonoma:        "68b278f1c3770de43facf11636d1d67e2aa53c1fab87ef6ba865c1154ccd6b70"
    sha256 cellar: :any,                 ventura:       "8f0f1b0fbdd8d933db23acfdacf8caab70cf1f7a82d7c996b28e0f0c5f59a2ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ea8a328474cbfdb06bd0b19d29a12381e4a12dae09366392d87737851c3c6f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c77a81f4455938891f7f5e2c572ec8bed6ed8539cffa3764964db085a173e970"
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
