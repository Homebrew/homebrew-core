class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.18.tar.gz"
  sha256 "225d982bcaf553221c76726358d2ea139bb34913180b20823c782cede060affd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fbdd26e8167677d0ee5ee7f18cc94a98872044715f077b1d8e9bd9216cd37f5d"
    sha256 cellar: :any,                 arm64_monterey: "5116d8574dbe9f484c777033dafa9eb13232affd31398419f4ca2ac431b395c3"
    sha256 cellar: :any,                 arm64_big_sur:  "3a3a2550934d65a7cafdbd6271480418797d6d5814d98941a4ef64d299b37bba"
    sha256 cellar: :any,                 ventura:        "7229977b7c53d87560d1083e62add965f7fa0d9cec3b9e910529a95ef3b63a55"
    sha256 cellar: :any,                 monterey:       "e675068af0ccfc0e3a406e7cfacfeb38d8b6f263cd0cae6846d1057a3d3c5bb6"
    sha256 cellar: :any,                 big_sur:        "0a5189b08de91223c396a8a5917402bf071f11337f00cb90b0f220dc66dffc9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7296fdcdfd35bf16b31f76d703746c0d6c67c9597cd29278ddbae18548614b38"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/libdeflate-gzip", "foo"
    system "#{bin}/libdeflate-gunzip", "-d", "foo.gz"
    assert_equal "test", File.read(testpath/"foo")
  end
end
