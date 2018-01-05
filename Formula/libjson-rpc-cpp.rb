class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.1.0.tar.gz"
  sha256 "8e699cad9f64e5db5c855ddfb6900dc55e673cc960cb9158818d652b74cb9183"
  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    cellar :any
    sha256 "a0bf45eab53c074d1a7db06b07d208a25eb1f004732fc331854b016af491d757" => :high_sierra
    sha256 "4202093dd4d26177adf295ec6c7e81df4a32be060f5599de80cbeb24b45640e5" => :sierra
    sha256 "cfb154a79679e34ec52c03eebf077ebb9d6d81c6bddd4a21d43fb49fee8f812d" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"
  depends_on "hiredis"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end
