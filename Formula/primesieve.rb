class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/v7.9.tar.gz"
  sha256 "c567f2a1a9d46a70020f920eb2c794142528a31a055995500e7fcb19642b7c91"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "adf30b1134b1704cad2bf4995b815932393d50046d203f2ca8d2cdf51a1315b8"
    sha256 cellar: :any,                 arm64_big_sur:  "0c9982a14171709de0381a3f39fa9ff2528416ac056f768f963bed9a125e7f61"
    sha256 cellar: :any,                 monterey:       "0ab03ec9e809c917a3bef7a14db0a9c6a296a9a3f7d456bf32c77824d3435e61"
    sha256 cellar: :any,                 big_sur:        "4f9a4873dee72a4466630609c610863781eef59b8cf290c5666394ab6604f974"
    sha256 cellar: :any,                 catalina:       "a82b43b80f8372ae3e85a322c7e84856cdebc407b86c2c9c66b2cf0051d1a267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44679f7c19d5183cdd8b66605f248bae3d56f7430a3ad6bc3cd6c0eb5051dcb7"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end
