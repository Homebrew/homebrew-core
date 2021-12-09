class Functionalplus < Formula
  desc "Functional Programming Library for C++"
  homepage "https://github.com/Dobiasd/FunctionalPlus"
  url "https://github.com/Dobiasd/FunctionalPlus/archive/v0.2.18-p0.tar.gz"
  version "0.2.18"
  sha256 "ffc63fc86f89a205accafa85c35790eda307adf5f1d6d51bb7ceb5c5e21e013b"
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
    sha256 cellar: :any_skip_relocation, all: "75932df0bb790fd5795b12c967931873d950a7e47c551138675ea2a08216bead"
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
