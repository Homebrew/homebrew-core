class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/refs/tags/v12.6.tar.gz"
  sha256 "677c1c5046e666a25e6248f3242c0b27a09953f2775fc4507e4a017a47059345"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "07d6a532f82c5c76409dc0f3dd00fb6989d4177e9bb22e80088b3912326b7322"
    sha256 cellar: :any,                 arm64_sonoma:  "c3156262c3a3d0eebd52eeb5cb59ec9808500e8e32a621bcced81fd6bf9cea40"
    sha256 cellar: :any,                 arm64_ventura: "5a45b133d9442c7330f59a756fe5f97b6e14788ce642e4de97a415c48a2a6bab"
    sha256 cellar: :any,                 sonoma:        "854ad2e82c9e765b89a5a5ddcbe6cf73e9157b50dfb1db2387399ca4d9fe2adc"
    sha256 cellar: :any,                 ventura:       "594e6db8ccd3702d089c3c41504e4e7831287e9838080db07b23c3b0a36e45fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a056fcc9a30f642e7c40fda73875ad3ffb19971a69d22b8d3905c155da90c1b"
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
