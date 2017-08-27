class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.0.0.tar.gz"
  sha256 "888c10f4be145dfe99e007d5298c90764fb73b58effb2c6a3fc522a5b60a18c6"

  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    cellar :any
    sha256 "e3330fc67b95a5fcca66178e55bf60b382c5298c85d68489eb9074475a056dbb" => :sierra
    sha256 "4f526c8b02e430fabdf7b8ed07db491ae762936c6a4c7f767eefe21bf2417636" => :el_capitan
    sha256 "69f12426a969f5d29617983bb0228d286a0d6df5b36212a4488a1583f50de3f5" => :yosemite
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
