class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.3.0.tar.gz"
  sha256 "cf132ad9697b034f22ff37d12a1f1c6f2647ec2236701de5e76f6036ab664156"
  license "MIT"
  revision 2
  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "66710525dfe087cf3fa90cd9880b9d2a46a45e1b9d5baf2f1742cd3aa32ee019" => :big_sur
    sha256 "1f790d2b77bc7dd5fedc0aed3982162212216196dc9b292d3c7871aea73b5383" => :catalina
    sha256 "c4a5604efe261cddd6f8aa87a6c615251eab3a78f922b80186dfdf136e9a7b7f" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "hiredis"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"

  uses_from_macos "curl"

  # Fix for https://github.com/cinemast/libjson-rpc-cpp/issues/298
  patch do
    url "https://github.com/cinemast/libjson-rpc-cpp/commit/fa163678134aced775651558f91a006791e26ef8.patch?full_index=1"
    sha256 "80a8cdfa40aba3dc71fbab77b0137f7f03bb9c969b9845e68f83181b4d8550f6"
  end

  def install
    system "cmake", ".", *std_cmake_args, "-DCOMPILE_EXAMPLES=OFF", "-DCOMPILE_TESTS=OFF"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end
