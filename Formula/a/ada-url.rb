class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v3.2.4.tar.gz"
  sha256 "ce79b8fb0f6be6af3762a16c5488cbcd38c31d0655313a7030972a7eb2bda9e5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "888a54a0561d8d7df2d92ee25552177c7f1145b6ca8606389284b313d7808f45"
    sha256 cellar: :any,                 arm64_sonoma:  "5e41211a52b56f862011aedd58db319d1296928584ac450175f6d690283102cd"
    sha256 cellar: :any,                 arm64_ventura: "46c45697c40bae733701646a8496174268663721622865d65a0289f2135747e8"
    sha256 cellar: :any,                 sonoma:        "0c034aa863f191ba9552202711d1dd6265223f6993e9cf39c4d057ee40580d24"
    sha256 cellar: :any,                 ventura:       "2d82d7336972b9bf78964bde91c5dd863d96f95e59fe758f881986357353952f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "107755dc326c42bc1e82f909f15ae7b8e25fcb6ef453c563caf7e39c677842a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bdbaddff93b1b3957c223fd1d713736c949d8c088bb2707e6b5870ba1028184"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++" if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    (testpath/"test.cpp").write <<~CPP
      #include "ada.h"
      #include <iostream>

      int main(int , char *[]) {
        auto url = ada::parse<ada::url_aggregator>("https://www.github.com/ada-url/ada");
        url->set_protocol("http");
        std::cout << url->get_protocol() << std::endl;
        return EXIT_SUCCESS;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++20",
           "-I#{include}", "-L#{lib}", "-lada", "-o", "test"
    assert_equal "http:", shell_output("./test").chomp
  end
end
