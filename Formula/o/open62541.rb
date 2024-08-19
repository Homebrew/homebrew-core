class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "8d92d4d7b293612efcd87bfe3b833fc2a953d83e4d58045a9186b6cacaad4c58"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ecf92b2374290a7507643e9a2e64d4fcae14ba5f3879334360e59ff4ce0b0026"
    sha256 cellar: :any,                 arm64_ventura:  "7734ce615d9d9d601a290de41dd2397e52b4e400dc3ec8a5c89bb3113a5940be"
    sha256 cellar: :any,                 arm64_monterey: "a572926a8cd09d7d277044da3c66e0ca5953661b1e7842ec0f4f55ea37a5cf47"
    sha256 cellar: :any,                 sonoma:         "23fa02d4c9d88af431af5b36782c76dea94713618f65c2ee5901dea323e7eeb8"
    sha256 cellar: :any,                 ventura:        "b50be8010c892ffbd1cf36d09eedf20cf4e56d2ab3adace458bc7bbd7ee98ef7"
    sha256 cellar: :any,                 monterey:       "92178d27493c2a2bce4940278bb6e658890a731334b75134c9009715d463cdfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "721dd67aa3523b8fcae6a1aca7220e0c3e9df0b5e86e90d3f6295cf09021cf75"
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
