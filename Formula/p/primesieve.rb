class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/refs/tags/v11.2.tar.gz"
  sha256 "86c31bae9c378340b19669eafef8c5e45849adf7b9c92af1d212a2a2bfa0a5db"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c554fe8c6e5545cd9b570931791f7cad2440ffa31fe9087748f403debc03baf6"
    sha256 cellar: :any,                 arm64_ventura:  "6edf3adda232c1585500ca4ea41b9c14c8f82d29db3f7ea42edc6c9671ac6527"
    sha256 cellar: :any,                 arm64_monterey: "a7fa0584a0c7004e81fa6c40713546cc207a45ecafdad3925549ae04727f36db"
    sha256 cellar: :any,                 sonoma:         "c784d89196a0482719a50284d20dc8f2d74759b85785b55d3745814097f12498"
    sha256 cellar: :any,                 ventura:        "67583054ab17a56f6b39c12b399cb4a1bb9ec6eb6760b0b3923bc17f5965b541"
    sha256 cellar: :any,                 monterey:       "ed8573067b089a3c3d9b4faaba28dcd2fe5c889b3c8371c6dc2ae28e280bd16a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69d70d9af64bc8162960dcb581d7b34ffa96d4f20cc10e8dacf26e1360ef35f4"
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
