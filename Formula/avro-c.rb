class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.10.0/c/avro-c-1.10.0.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.10.0/c/avro-c-1.10.0.tar.gz"
  sha256 "3ee583d4c370ca6176e9d74f8a6f51ce97edff9b9c7146a8e23bfae31f33051e"

  bottle do
    sha256 "ad0ea0e835b07b6e2e9bf152c6a207a032b6aa6a99d7ba8c9df5463d39fb5eeb" => :catalina
    sha256 "45832acdf64f958cfa8a84a5f2121a44ffefdb788b67a47c542e870198e60b63" => :mojave
    sha256 "3c61ea219581bcd0386da82113d5f7998823852d662385b7da144ba4456d33ff" => :high_sierra
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
