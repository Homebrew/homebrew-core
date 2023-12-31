class Functionalplus < Formula
  desc "Functional Programming Library for C++"
  homepage "https://github.com/Dobiasd/FunctionalPlus"
  url "https://github.com/Dobiasd/FunctionalPlus/archive/refs/tags/v0.2.21-p0.tar.gz"
  version "0.2.21"
  sha256 "d8ce124ac4be887debff825d6925d8505311305c8a968586285ae44516763a71"
  license "BSL-1.0"
  head "https://github.com/Dobiasd/FunctionalPlus.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]p\d+)?)$/i)
    strategy :git do |tags, regex|
      # Omit `-p0` suffix but allow `-p1`, etc.
      tags.map { |tag| tag[regex, 1]&.sub(/[._-]p0/i, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d84d2d6b06cb737b2e409fe60122deb0e0a4a8bb09d1713c314015a79302b64d"
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
