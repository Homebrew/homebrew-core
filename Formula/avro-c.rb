class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.8.1/c/avro-c-1.8.1.tar.gz"
  sha256 "e5042088fa47e1aa2860c5cfed0bd061d81f9e96628f8b4d87a24d9b8c5e4ecc"
  revision 1

  bottle do
    cellar :any
    sha256 "2ac1ff52207a67f9efd9b62c616122472897183fd0823950e3b67e2ba72da6c6" => :sierra
    sha256 "e4a3fac26f221aba730618345e9f024bce23b852d8318d59f95feff1adc5d20f" => :el_capitan
    sha256 "3a486446c6a1b9ae93b0501214a42f54d14b9753646fbe3a8ec2b03025b476cc" => :yosemite
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
  end
end
