class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.8.2/c/avro-c-1.8.2.tar.gz"
  sha256 "4639982b2b8fbd91fc7128fef672207129c959bb7900dd64b077ce4206edf10e"

  bottle do
    cellar :any
    sha256 "7f3b7576204b4741e355ecb75ffc7cf8624a1d3d5b9b4763914b350dc44a4035" => :high_sierra
    sha256 "babc65c0442620b00470abdda6d86d7035390b75b6ae113319c69df1fc24dc8b" => :sierra
    sha256 "52ba34bf67cee89d559bd075baff35e7be512b5f53419783a82c1f0cf2ca3f8a" => :el_capitan
    sha256 "f77867d708068930b40fb0e3e4e5bd5146487699599e87d4987c205fb6a3275d" => :yosemite
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
