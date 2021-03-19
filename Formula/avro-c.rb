class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.10.2/c/avro-c-1.10.2.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.10.2/c/avro-c-1.10.2.tar.gz"
  sha256 "ae3fb32bec4a0689f5467e09201192edc6e8f342134ef06ad452ca870f56b7e2"
  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "e4cd6b302cfadbcd1f445c8957fd616b5f2fdc6730ca64ab3c825cd81a9d8dc5"
    sha256 big_sur:       "c99913941625740c45fd76a1fa8a69750f585375c0559af04284d8bed2cab872"
    sha256 catalina:      "2b10e0adb725faf050ecc7c3ffccec6f9a003714ccd76d544b0d644253d2626f"
    sha256 mojave:        "0fc00159098c04997d2537f79283517497f01a8100a4a3cba8ac09099844a80f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "snappy"
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "tests/test_avro_1087"
  end

  test do
    assert shell_output("#{pkgshare}/test_avro_1087")
  end
end
