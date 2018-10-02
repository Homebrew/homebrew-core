class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.8.2/c/avro-c-1.8.2.tar.gz"
  sha256 "4639982b2b8fbd91fc7128fef672207129c959bb7900dd64b077ce4206edf10e"
  revision 1

  bottle do
    sha256 "072eff37263bbd6dfa941cb350ffd2ea7ee6e23e948547f8c9c6f3b58e162211" => :mojave
    sha256 "845eb5220229a26d3acd435beb093301207850787827a84db0d55455357f18dd" => :high_sierra
    sha256 "442b64624539b8454693b961ac9b455f2ad956c1119cb16e49c65498caeb1e81" => :sierra
    sha256 "6282882c11af83fe568776fa45c11c5140dec413a6cd4efff9e28b2ffc35713c" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "snappy"
  depends_on "xz"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "tests/test_avro_1087"
  end

  test do
    assert shell_output("#{pkgshare}/test_avro_1087")
  end
end
