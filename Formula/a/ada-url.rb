class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "525890a87a002b1cc14c091800c53dcf4a24746dbfc5e3b8a9c80490daad9263"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "739c5139b3e763f44f52fe88a7ff99318cb61e9c89ed33ad8b127daea2e0281f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5097b840139824ae60d2cfdbf58f0d8d796ca44c99998488204449887345f974"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8daaf099011c96704ba9a8582ebc4840d32b2df76359b9e58c5c0f2d8a3d6dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ac8000180cd8fb8c3715dad105f2c5b5850dd39378c1203d46edfb5cc143924"
    sha256 cellar: :any_skip_relocation, ventura:       "c092a3f8b7f90dec4d421cdc419599dd8117fac40e9405b16d52e5260a6e7845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68a3227288c9fde80005ba0a48bc30a02042071221d3bba53af0b7f5c1335d2f"
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

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
