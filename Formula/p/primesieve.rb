class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/refs/tags/v12.11.tar.gz"
  sha256 "a4f15a055a60fcc5b2198335ca39f3e78cf9eade4b2fe258fe16b3bf1ba4abbb"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f3e44bd724601327a982ec9a98a9700cfccc2ff1dcc9a73e311f4725bbe05480"
    sha256 cellar: :any,                 arm64_sequoia: "e4b94e44eacd63ca7e3bf0c45afdd783d20bff9b79905625768203ce6fdcb887"
    sha256 cellar: :any,                 arm64_sonoma:  "3dcdd448317dc9d37e52ea520870fd24a7441bfd7f80ce3aa68b9503553055f8"
    sha256 cellar: :any,                 sonoma:        "430d5ed46d0390f23f3a4c51fbf05f7ee549c3a9b43f24cdcab62a6bcae0542d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79cd7a47dbf4124d654b98edb32eb5f2362298a094510cfb8d456ecdee24879b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5ae8113f0a6ff1a29f57eb0b4a50137c650a62e3adc8f63c7494a4c3f068b12"
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
