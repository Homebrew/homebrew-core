class Functionalplus < Formula
  desc "Functional Programming Library for C++"
  homepage "https://github.com/Dobiasd/FunctionalPlus"
  url "https://github.com/Dobiasd/FunctionalPlus/archive/v0.2.8-p0.tar.gz"
  version "0.2.8"
  sha256 "4a10a981e30b5b63e5b1334c41cfb3aa9aeb02b25dd154f546bed2c39dc463c1"
  license "BSL-1.0"
  head "https://github.com/Dobiasd/FunctionalPlus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5db198059a4d3219e1195d179b0b595bd8fc483965ecd6f438fbd3b8c127cec6" => :catalina
    sha256 "5db198059a4d3219e1195d179b0b595bd8fc483965ecd6f438fbd3b8c127cec6" => :mojave
    sha256 "5db198059a4d3219e1195d179b0b595bd8fc483965ecd6f438fbd3b8c127cec6" => :high_sierra
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
