class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.8.2/c/avro-c-1.8.2.tar.gz"
  sha256 "4639982b2b8fbd91fc7128fef672207129c959bb7900dd64b077ce4206edf10e"

  bottle do
    rebuild 1
    sha256 "6f4d948dcf0e1700b7a770f9bb8612f5495ff0c5c01c9f0ee3a73f3d3c58165e" => :high_sierra
    sha256 "b1340938b27551d73c1343d5323b9aa1a42a173fa10e4a7db9445e11e84fdc54" => :sierra
    sha256 "8358b34088a77ba07d32505350e5b119274ed69f3adf1016cd1fbf0b15034227" => :el_capitan
  end

  option "with-snappy", "Build with Snappy codec support"
  option "with-xz", "Build with LZMA codec support"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "jansson"
  depends_on "snappy" => :optional
  depends_on "xz" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "tests/test_avro_1087"
  end

  test do
    assert shell_output("#{pkgshare}/test_avro_1087")
  end
end
