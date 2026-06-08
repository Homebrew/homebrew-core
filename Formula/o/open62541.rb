class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "fb5aafc19c67a91368d1f71d9ee4acf0f4b47a0d65c66db4ed738691828779c7"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1208b18d4915b983cc44ee4653a14e5f32e3f26151f6f20875ef1f5ba52423bc"
    sha256 cellar: :any,                 arm64_sequoia: "35bb54af14b1e8eee13b2688bdd16869753a8cc2dcca6bfc58c0ee5060f30420"
    sha256 cellar: :any,                 arm64_sonoma:  "357c53eb84253d16d44b02d5f00d60c09bef5ed34a318f1f455fdcae7b28be3e"
    sha256 cellar: :any,                 sonoma:        "2261d6e288243f2049397babd388a8849b45e9167f7bdb2a69e135f903300352"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b24393c7d7be2ef1fe99ed31f4ec5d8c4ca156276f579c6f6bacec2f872c0c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40bc82d3ba23db50ecdd6cd96c427af9dd58ceee032fcd490f27451e43d439b0"
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
