class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/v11.0.tar.gz"
  sha256 "b29a7ec855764ce7474d00be03e1d83209bd097faa3778382dfb73a06866097e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f9a122d2520d8fc54e470cc3be41ff83a156e6f2e117a1aaca1ac6b40ba7c895"
    sha256 cellar: :any,                 arm64_monterey: "68f03897bf251410d02a82264ce7a21d9914e27b90e4e64b40ff4e061b94a2ef"
    sha256 cellar: :any,                 arm64_big_sur:  "5d6aa900eb2f1a060767d3b3f2a72840e7002c50aa279586605d41c1eebb2ae5"
    sha256 cellar: :any,                 ventura:        "448852ce7c9d31ea516b2687341cb1bba8b3ffead852fc874cfd3e8c43ce4385"
    sha256 cellar: :any,                 monterey:       "3a936ba7ab19bfedd3fbdfa4c4eacc853034cfcfaf9a5ce72d71e54d0d29033e"
    sha256 cellar: :any,                 big_sur:        "4bc5d1ae5d7b4c215cd3099cd01b4e92847adafbdd85c76b384683dbe5378e7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "934d3e36d0fca07908f66c1e33bd35e610544220e4b2eaf76e8603226b025f1c"
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
