class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.2.0.tar.gz"
  sha256 "485556bd27bd546c025d9f9a2f53e89b4460bf820fd5de847ede2539f7440091"
  revision 2
  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    cellar :any
    sha256 "93aabc3290ac1f6f62783c97820a298f32bb6d2eb174eef66ebd26198c8e7f85" => :mojave
    sha256 "3488b2b28b4b275aea373f5adf4bee029f21e1f59a6e4707b6b51c216d814db5" => :high_sierra
    sha256 "dfb299c3e6d21e1e2966b61f53e43a462f1daf6beed1245054ed7dc43c26582c" => :sierra
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
