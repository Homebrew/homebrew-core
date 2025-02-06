class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.4.10.tar.gz"
  sha256 "1a2e762e50bb6dae8d80029dfb66fdbc432876a004e62d618f7cf1bb5b4f495f"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0493d584a33cf1e56ca1a0b24cb88c9948bc8b05bca986594726380c30671bef"
    sha256 cellar: :any,                 arm64_sonoma:  "4223e38bd51fd7b848a8cdebc1d190b916783de12d2a969e8247aef8d3f75798"
    sha256 cellar: :any,                 arm64_ventura: "57d3e0619dda7bc8f15a35d44b4a35b8057e79702ef764918305ec83f237a8f9"
    sha256 cellar: :any,                 sonoma:        "086c0815c9d671a4890743765790ecb04dee8ae8dfe025310b4b53c55f5b5b9c"
    sha256 cellar: :any,                 ventura:       "a62ea26fa86a71d61c09464f508c44eaf4023042aa2700147ab3408551893123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e40a06787eba77e3b954a91b09dc2f9f0233e71098f3aa1e5e709b033005ad05"
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
