class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.11.0/c/avro-c-1.11.0.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.11.0/c/avro-c-1.11.0.tar.gz"
  sha256 "0652590a54ad8e4aa58a2b9ff1f4ce71a64a41b0a05c4529d1c518c61e760643"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "003f19bcd51baea53f86d97488f83552dc8477eedef78a371bdc166ac0d183ab"
    sha256 cellar: :any,                 arm64_big_sur:  "f30243ab877db4e81ff07c5dea0e266228ac04bf178144d3f9caaab45a876f86"
    sha256 cellar: :any,                 monterey:       "35a23d1c97d7e5b50adf7ff2f8ff3ddcb6f9271c85fc033306e8447484e23b5c"
    sha256 cellar: :any,                 big_sur:        "cbb5817beab9e6dfb2dd1a5fafed449c6aa5dabf8525b71142854771ba46ab35"
    sha256 cellar: :any,                 catalina:       "d91479cfd09b368e971ed2c926c480edfe88f62df39476e780ec0d863cc19dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80da35f4303fb1c13aa3a8728d2e4dd35537ba984a075531c2f7d17f6d03e823"
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
