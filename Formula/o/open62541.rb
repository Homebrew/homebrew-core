class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.5.8.tar.gz"
  sha256 "cf7951baf253c0537b3397e4ce3ff13930542abcb6ffc3b9cb082af88f95c300"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7d9da69e33ebe4f90c91ea2859730cc08e77bc39bf16e002ca0ba4365958118d"
    sha256 cellar: :any, arm64_tahoe:       "0d2c5923cece0b08717a9a9d191f8c3e81d62c23f63c848134e9cc6873315378"
    sha256 cellar: :any, arm64_sequoia:     "7cb5050f6ef7cef85a0a2dac5470e5d8eb372f8f81bf47f046c773bff14e881f"
    sha256 cellar: :any, arm64_sonoma:      "5a1f242bac7267e0291845229a0527fe33e353d1f416f30a4b2425e1667965b7"
    sha256 cellar: :any, arm64_linux:       "b1d5acf532c8f68dc77e1eb1a405190797039dee2223aa61849860b5d97a1cfb"
    sha256 cellar: :any, x86_64_linux:      "bd997eefc81d26ca5a097169f92aaf6e27799c594d7cfed2545f5333641fb432"
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
