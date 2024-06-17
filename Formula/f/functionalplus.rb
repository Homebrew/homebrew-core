class Functionalplus < Formula
  desc "Functional Programming Library for C++"
  homepage "https://github.com/Dobiasd/FunctionalPlus"
  url "https://github.com/Dobiasd/FunctionalPlus/archive/refs/tags/v0.2.24.tar.gz"
  sha256 "446c63ac3f2045e7587f694501882a3d7c7b962b70bcc08deacf5777bdaaff8c"
  license "BSL-1.0"
  head "https://github.com/Dobiasd/FunctionalPlus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7f4fbcb6e519656133e62498d6442eea713cf12de82c118e001c45dbfaa1e2df"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
