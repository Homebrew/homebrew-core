class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v3.2.5.tar.gz"
  sha256 "cfda162be4b4e30f368e404e8df6704cdb18f0f26c901bb2f0290150c91e04b5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f11b860cf7c0084a075ac62c2570cfa81bbc3e3c5a3edfc7531ca6fd45a12aef"
    sha256 cellar: :any,                 arm64_sonoma:  "63bb7ea0b4b1fdc6ed3ae9a61079bc3b7dfbdda8670c2d02b684dd4536b61ac4"
    sha256 cellar: :any,                 arm64_ventura: "9317d3130830eacf55d65410ee8018be48d641692393ba8d33dfa63817e31788"
    sha256 cellar: :any,                 sonoma:        "30f6c95cb9f521e1945c7b47793b85aaa0e9424f974fca71ec60cc12269f8919"
    sha256 cellar: :any,                 ventura:       "f6f4e9263c1feb16fd781c89e1b6ab0b07d09436fbcf72a75ece4281462b5322"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abb5425092a4c02b5915fbbb77ffe1c0f965e987b15363f5bdb46894fb3c91ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6a67e954e38af93923eae0493d09dea68e38b5bc123a20a282225ab7ea9fcb0"
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
    ENV.prepend_path "PATH", Formula["binutils"].opt_bin if OS.linux?

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
