class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/refs/tags/v12.9.tar.gz"
  sha256 "0638f82a3dc35c0dc0b598857dfd1bc280b6de71e930724a40a35af60b440278"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cc0679201b60d4ac4d6a7cd3c60b18678ad96d19eaab3a8dfe0d9e4e769072d4"
    sha256 cellar: :any,                 arm64_sonoma:  "a6383880f88712f8fd81d15a3b00591153e8a77f578cceae774ec904eb0922bc"
    sha256 cellar: :any,                 arm64_ventura: "8945ed23f37b449a3d56d9d0622ea6f78b3151ed11cd699f8c49ea5ea1125f05"
    sha256 cellar: :any,                 sonoma:        "03297c90a17bab55ce05fdfe1126f633314c034aac378009cba64483c92d8fb6"
    sha256 cellar: :any,                 ventura:       "e23540c21969a4cf2f34d57c5e0f107bfcf0de9de28ae07c2bd13a15a2ee61f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b628601087e0d1cebfb0e7ce72001740cc6e7c2f4b659635514709d91c9d71de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d1ff8dd0b14fd3c1269285ad76699b8fac6077feb8d5ed7bb1d09e34710f2ca"
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
