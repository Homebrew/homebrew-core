class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.10.2/c/avro-c-1.10.2.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.10.2/c/avro-c-1.10.2.tar.gz"
  sha256 "ae3fb32bec4a0689f5467e09201192edc6e8f342134ef06ad452ca870f56b7e2"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_big_sur: "a2574fe92f3872c88dba0a8c956f4dab956b9222111a49c9b9ea1d191ed1bd44"
    sha256                               big_sur:       "af1c754a9f9e63b2692de3d8dd466dfa44e22d45d5733ea40db9fba4ed7c4437"
    sha256                               catalina:      "3dfd6605930b99e96e1e78c2cbe6860e27d78cac3b1c6889050b7c05fdc32ad9"
    sha256                               mojave:        "e753230392158e5001990d7af043a62bea1156931cb30c7ff5684035fd12eb45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1316225f689809972553a1a9929339c91182f992b93773cc5b1ce4d0b7a5dcdd"
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
