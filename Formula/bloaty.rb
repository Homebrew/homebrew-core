class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 7

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bda2966a745c782a4a0e3959195f0d00228412f18f7701f4f7984fd0d32375ab"
    sha256 cellar: :any, big_sur:       "35e14304cbb8c06cd89f8603d05d5bc8c18144af5ca6f8462718421f9a807bf7"
    sha256 cellar: :any, catalina:      "5bc72e3e9ed4d182c70b0a14f9236d0957b8d80e87f448c12ed58f4c6c16f5c3"
    sha256 cellar: :any, mojave:        "33c8b5b8d008b587c1c6162cb6109c3ab59f79a84e5264d675ea2ba67f206718"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "protobuf"
  depends_on "re2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match(/100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL/,
                 shell_output("#{bin}/bloaty #{bin}/bloaty").lines.last)
  end
end
