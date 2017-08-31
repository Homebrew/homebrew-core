class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.0.0.tar.gz"
  sha256 "888c10f4be145dfe99e007d5298c90764fb73b58effb2c6a3fc522a5b60a18c6"
  revision 1
  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    cellar :any
    sha256 "5c54fb0c205776ccb7de5c430fbedc6a87b5915ed06c11d9fd00d1423d037d6c" => :sierra
    sha256 "718f8b639caa9a2252d0969b2383470671bb46de36a02edd8d9254224f213dd3" => :el_capitan
    sha256 "892c2c6f9d4a4b9d9de9b725923b725bf837703411119a9e8b519949d7e8f7f1" => :yosemite
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
