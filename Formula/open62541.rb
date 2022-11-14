class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "3489cfa2f98c52df252adc8e641a9e59cb675bdfd5ef413b0d947e667cddd16d"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "85293f5e208ac641c186a906b7a841489b4bd38d02b443acc5c4398bf9ab1eca"
    sha256 cellar: :any,                 arm64_monterey: "07478af723841eb386d0a00d3f202fa565bf307adec029732743fe913e4972fe"
    sha256 cellar: :any,                 arm64_big_sur:  "e3297ff0fe53a3f1f09d24aaac946724e436e5748605b367aa223de7328a7a84"
    sha256 cellar: :any,                 monterey:       "600fd9b32911885b3587583f174c65c2f35f5d09488b327f17248155ded73e90"
    sha256 cellar: :any,                 big_sur:        "561390143dc08bb6c8e1daea0bc0f1b1fb6fa05a3582d2c77983f734d90bde5a"
    sha256 cellar: :any,                 catalina:       "3480fc2987acf0c6ed31a7e2ca2e097387fbc975a242ca5df45a1f3e6e088135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cb186e44edfd0827e567f2da9eee0e185bb77743622990d8db36c014554241e"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

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
