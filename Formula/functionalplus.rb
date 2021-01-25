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
    sha256 "244d54ac6b458a8f170a5eba497817b5b22b374e834d65537d674ab9e39c666c" => :big_sur
    sha256 "f924c8c83fcdc4d22a32166a3b0c29a213951ff5f27e139bdc6eb3c26d795714" => :arm64_big_sur
    sha256 "73e1e7337735aefb7deed60dd5a2fa21f6e08852c3ed2b030e599196c7af2328" => :catalina
    sha256 "7c71a5c706e7b89288b9f9897eaee2a22f4b375ef710c68d94fe131b012daa6d" => :mojave
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
