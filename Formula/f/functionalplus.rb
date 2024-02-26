class Functionalplus < Formula
  desc "Functional Programming Library for C++"
  homepage "https://github.com/Dobiasd/FunctionalPlus"
  url "https://github.com/Dobiasd/FunctionalPlus/archive/refs/tags/v0.2.23.tar.gz"
  sha256 "5c2d28d2ba7d0cdeab9e31bbf2e7f8a9d6f2ff6111a54bfc11d1b05422096f19"
  license "BSL-1.0"
  head "https://github.com/Dobiasd/FunctionalPlus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "24b7d4740aafd50ae44cd33d989e20c26c8efb6269c172f8d4f1374d1ac6f7fb"
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
