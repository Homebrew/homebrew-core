class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.4.1.tar.gz"
  sha256 "7a057e50d6203e4ea0a10ba5e4dbf344c48b177e5a3bf82e850eb3a783c11eb5"
  license "MIT"
  revision 1
  head "https://github.com/cinemast/libjson-rpc-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "92aa868394bc65515e1c39a53afa9a28b5ce68fbad43cc41fbb89850567b5b01"
    sha256 cellar: :any,                 arm64_big_sur:  "38c70b350ea44a23e38ce549b998e7314dd85528bb89f63acc92c31f983e5ceb"
    sha256 cellar: :any,                 monterey:       "44c292ca252bd482fce41e1b0587a55671a3c5085ee46d55345357b3d2386079"
    sha256 cellar: :any,                 big_sur:        "e7e1d233b08f2f8475c41caa0976b0543c7208f6ce946d9b2e9700ec9bf35bbc"
    sha256 cellar: :any,                 catalina:       "7812baf2337ad266cd66c113461f79f0fd1035a1ef44c698178efe6415f4285c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72909ebf97a0de14f83f54bc1ac1d6cc8b1cfce2bb96754e522705fad66412d3"
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
