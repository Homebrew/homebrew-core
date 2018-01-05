class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.1.0.tar.gz"
  sha256 "8e699cad9f64e5db5c855ddfb6900dc55e673cc960cb9158818d652b74cb9183"
  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    cellar :any
    sha256 "e5d4cc49afc50d844b8b6cc74a33606ba3edd514fc31ac3bc24bd0321975f984" => :high_sierra
    sha256 "2e0fba342ff4b2912ec0df0293a4fa9f95b3cc33a424eb5bbc57c3819d337470" => :sierra
    sha256 "08cbd358998f26882aec42e81c4f24a7fbb244c1769597ac62e3e4dc738bc479" => :el_capitan
    sha256 "9711596b93811aed07a7308097c39d39c7ac4d5b7b7be57be59f57567def7c81" => :yosemite
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
