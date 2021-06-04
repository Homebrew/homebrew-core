class Functionalplus < Formula
  desc "Functional Programming Library for C++"
  homepage "https://github.com/Dobiasd/FunctionalPlus"
  url "https://github.com/Dobiasd/FunctionalPlus/archive/v0.2.14-p0.tar.gz"
  version "0.2.14"
  sha256 "68a0e715aa18d2fe558fede06d65ec125959895efe4d0ef21b102037c9864ba1"
  license "BSL-1.0"
  head "https://github.com/Dobiasd/FunctionalPlus.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2d9d54699712e47f98c9ca5444d9010ebfe97abf94b411ca0d63889003782771"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fplus/fplus.hpp>
      #include <iostream>
      int main() {
        std::list<std::string> things = {"same old", "same old"};
        if (fplus::all_the_same(things))
          std::cout << "All things being equal." << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-o", "test"
    assert_match "All things being equal.", shell_output("./test")
  end
end
