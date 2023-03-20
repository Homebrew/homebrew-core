class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "308aa8845f9cc3a99427636d2282e9bed2a26fbc8a404fe2ad1699146e4f4342"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b74b8dcd55fa927e4a7905b0bff620250346e9faaf3504b542706284b846693"
    sha256 cellar: :any,                 arm64_monterey: "29283ca7f3d6f3a36a199a2227ae8e70f2055338d914adcfd8fcc9cbd4645bda"
    sha256 cellar: :any,                 arm64_big_sur:  "5fd52ac69c445e2c1cfd99c7924639bf7e129a0200ee148ad4db591a2a407d2a"
    sha256 cellar: :any,                 ventura:        "b2329eb16235cc2d17c594e80feaca4102cfaf968886322919f30ae8a2dd2ce3"
    sha256 cellar: :any,                 monterey:       "1b9981c3f359b0d3cb3a111f681798a5177ac9af8b06e69b0e9b2950a71cb788"
    sha256 cellar: :any,                 big_sur:        "c601550c7bd9edb9fcd1a300ea5071fc091ca51985c285aa6e087579ecdb4a40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "239d383e1a33c96d8eb7ecc8701ac22ad79bd6ea18fcf32156688a1a0e800976"
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
