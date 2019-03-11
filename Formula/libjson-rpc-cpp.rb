class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.1.1.tar.gz"
  sha256 "ecfad0b5ac775f771471b5f22140fd8bbf273ab1cfa405d18d6683aba098562b"
  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    cellar :any
    sha256 "94278cc62c0e7a0c49d9fbe0125a5d3f6b354d317540bd65a7b39606c686ca68" => :mojave
    sha256 "be1196fb4ae8d9ec49a1be7432bf319537e3dd40497771b6144d32d6f7bfe49a" => :high_sierra
    sha256 "91e9b7ec9e5aa10f007c4ae15e9debedc9a2105a8e67153d38fcd19afb5dd597" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "hiredis"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end
