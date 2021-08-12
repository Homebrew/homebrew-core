class Functionalplus < Formula
  desc "Functional Programming Library for C++"
  homepage "https://github.com/Dobiasd/FunctionalPlus"
  url "https://github.com/Dobiasd/FunctionalPlus/archive/v0.2.15-p0.tar.gz"
  version "0.2.15"
  sha256 "4c76104ec8f6da5e66ed768380bdf128e0ba01725056c40a3c1b850cf4b441ad"
  license "BSL-1.0"
  head "https://github.com/Dobiasd/FunctionalPlus.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]p\d+)?)$/i)
    strategy :git do |tags, regex|
      # Omit `-p0` suffix but allow `-p1`, etc.
      tags.map { |tag| tag[regex, 1]&.sub(/[._-]p0/i, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab75da7d297b2258e1e906027bd3d5abe6b7464339288730eae5fec22b931715"
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
