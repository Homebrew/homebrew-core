class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.10.1/c/avro-c-1.10.1.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.10.1/c/avro-c-1.10.1.tar.gz"
  sha256 "5313dcb6d240b919f218a80a8b9b58f7a3eb501ff177b0dedc1c0595d0ee916d"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "c99913941625740c45fd76a1fa8a69750f585375c0559af04284d8bed2cab872" => :big_sur
    sha256 "e4cd6b302cfadbcd1f445c8957fd616b5f2fdc6730ca64ab3c825cd81a9d8dc5" => :arm64_big_sur
    sha256 "2b10e0adb725faf050ecc7c3ffccec6f9a003714ccd76d544b0d644253d2626f" => :catalina
    sha256 "0fc00159098c04997d2537f79283517497f01a8100a4a3cba8ac09099844a80f" => :mojave
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
