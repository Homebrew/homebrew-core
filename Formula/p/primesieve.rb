class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/refs/tags/v12.7.tar.gz"
  sha256 "c29d5173266f39804fa607783163c823eb1112132d4c68884e20a54b1a30f9f5"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8c5727c818efd48b4f28fd3e97449fa870c5614c6ed4c337eff1825dd5690a2e"
    sha256 cellar: :any,                 arm64_sonoma:  "87d1bdc935b9be4383d580f33bc58a145ff490a2d3214dc8426a23f54b29722d"
    sha256 cellar: :any,                 arm64_ventura: "807a1a9cef1a7e95879308de7bcbdae314e646492d8cfe22f3bb3b5eb49c4546"
    sha256 cellar: :any,                 sonoma:        "77c992d7f04fbdca931b261b3ad57450de07122c850c3d65109cc92f333b22f8"
    sha256 cellar: :any,                 ventura:       "bdf91c3935b7a4073985b3136b3353d7b5ad47ae4acf5d250bfba0b68d3187d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d688e10b42667ba1acec8149a80239f0a90b55f9112f112d07b0b112585810c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc89516ef01b1057ae25b5d987ae5c4fafe800702de3fb323e6069536c656131"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"primesieve", "100", "--count", "--print"
  end
end
