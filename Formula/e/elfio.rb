class Elfio < Formula
  desc "Header-only C++ library for reading and generating ELF files"
  homepage "https://serge1.github.io/ELFIO"
  url "https://github.com/serge1/ELFIO/archive/refs/tags/Release_3.12.tar.gz"
  sha256 "e4ebc9ce3d6916461bc3e7765bb45e6210f0a9b93978bf91e59b05388c024489"
  license "MIT"
  head "https://github.com/serge1/ELFIO.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "195ef71a662681ff1d1eb3f822c1853680911960d9487d4056493a438694c5e7"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <elfio/elfio.hpp>

      using namespace ELFIO;

      int main(int argc, char** argv) {
        elfio reader;
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-std=c++17"
    system "./test"
  end
end
