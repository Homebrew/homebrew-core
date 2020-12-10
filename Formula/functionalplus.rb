class Functionalplus < Formula
  desc "Functional Programming Library for C++"
  homepage "https://github.com/Dobiasd/FunctionalPlus"
  url "https://github.com/Dobiasd/FunctionalPlus/archive/v0.2.13-p0.tar.gz"
  version "0.2.13"
  sha256 "62f61ce6500859f0d77306b1644b5c6992287688de38e170b17b8a66b2448b54"
  license "BSL-1.0"
  head "https://github.com/Dobiasd/FunctionalPlus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e30a27bf78a8820d4d63a4ae87520afc97d3f1a0d93ac650b7a9fad79589b47a" => :big_sur
    sha256 "8fee519ccd0485bd871b10f8d12d2324efd929c69d8b2aac3754fb47a4313e2c" => :catalina
    sha256 "d4785dd619c7e46280a175f47ccf8dab03c076190fd2c5a11724bfae6d785e1d" => :mojave
    sha256 "5102b2c7d93ed23aa46aa46e8c455b0edd2b54556c69be9aa459775a2faeed1d" => :high_sierra
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
