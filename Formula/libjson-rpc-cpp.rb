class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.3.0.tar.gz"
  sha256 "cf132ad9697b034f22ff37d12a1f1c6f2647ec2236701de5e76f6036ab664156"
  license "MIT"
  revision 1
  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    cellar :any
    sha256 "b8a99a97b7ebbcb40cc19ad3f4805a93270e376fe7ef4ccbc02235c0f94f4c74" => :catalina
    sha256 "15fbc327291d065a0a691f14ea90367923296da22a4012247a2083ebec8eca3b" => :mojave
    sha256 "d3e24865583d50b44a833b08fb90093a2db62bda4615e3c734ffe5cd2bda23ff" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "hiredis"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"

  uses_from_macos "curl"

  def install
    system "cmake", ".", *std_cmake_args, "-DCOMPILE_EXAMPLES=OFF", "-DCOMPILE_TESTS=OFF"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end
