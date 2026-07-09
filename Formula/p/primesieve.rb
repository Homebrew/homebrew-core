class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/refs/tags/v12.14.tar.gz"
  sha256 "65cf173e11bc9aff1b189f2cd19c6b6c502c30e966876b5c5ef71e138f49c8c9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6cf0b345c9d3d89c751dfc371d839e6c0c557b66d21ff973c446a328c99710e0"
    sha256 cellar: :any,                 arm64_sequoia: "2511a1babcfcc81c7bb6d1342a6ac4b4ca1bcae2b5eccd4bea8ef9cb4a044451"
    sha256 cellar: :any,                 arm64_sonoma:  "5ad936c2d51ecafa8a332b601f4072a5563395c25bc85f0540a7ad6903e53285"
    sha256 cellar: :any,                 sonoma:        "0354b8003c39762e18663bdd92a0601d1c40abd5b77ac18d8aceed077c0cc8fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c77f45f2817feb3987a120f413d6294c6759d8ec25524bd4b3f1831b282636f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61702592f366a1fa27fb590741a461c05f75b542d6210338be46413e8a5d09a1"
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
