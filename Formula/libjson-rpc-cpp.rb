class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.4.0.tar.gz"
  sha256 "8fef7628eadbc0271c685310082ef4c47f1577c3df2e4c8bd582613d1bd10599"
  license "MIT"
  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2d5595ba06ed6242ea57d93dffc02fbdd17acf0a59ef9c49a3fd5b248e0fd6cc"
    sha256 cellar: :any,                 arm64_big_sur:  "8f6b4c50f9a8ba7f677f13ee5c3b8edbe18595c738093483ca77ae081949e7d9"
    sha256 cellar: :any,                 monterey:       "b55de462ab58927008ac9aab8dfd734f17fe3d2ae8c784cabcc8516f9c459e27"
    sha256 cellar: :any,                 big_sur:        "2665a82edb0caedbfdc16db5c9737bf9ce7d010312e4ef6959cac058ee880030"
    sha256 cellar: :any,                 catalina:       "168b837f3b9eb9000703524bb3b61a04db09707de52d5bb6891e3a03f558da19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "388a0dfab5687e1031a4cf317aaae62c5e2673a58197da76547ac8b6e15cb1fc"
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
