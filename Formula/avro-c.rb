class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.9.0/c/avro-c-1.9.0.tar.gz"
  sha256 "80568644384828b7f926efe76965907c8fff0c49e02301bfe8b2cb7965fa08b2"

  bottle do
    sha256 "72fbe9c22be502351d5dcffcb37a97c754f3bb3057742bf31b185b0a0f1d5eb4" => :mojave
    sha256 "6a8b708a052cd04ffb7135b4d69b0f6b6a60ac83dc071622dfaf241f26998c79" => :high_sierra
    sha256 "e194efdbbebb86f6f553b039251165fa87646a4e21d29916560f6ce73ef8281b" => :sierra
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
