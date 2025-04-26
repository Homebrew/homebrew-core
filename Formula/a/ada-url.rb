class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "8b9aa4dff92772d0029d8bc1f3f704afe34a899e23334bf04c7f0d019a5071c2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "46c46076389ab93801d6ec15b47af43ebcd070796b9d32a985ee02208efa829e"
    sha256 cellar: :any,                 arm64_sonoma:  "4232f3f373de8dcf291ca3e2cc2ec72cb0957e99c7f3b1a941a18edf388625fd"
    sha256 cellar: :any,                 arm64_ventura: "057a79d7012f70f820998fdb6c865a65b1a7d8dc46ee7beb9a8f4b7bceadc990"
    sha256 cellar: :any,                 sonoma:        "4a77e1e446e4da0cd7bda52bda22699fb2617d876e09e85219e97e130cf43c3c"
    sha256 cellar: :any,                 ventura:       "65111c5bfeea0dd3574a93c3a6e62a3ac6df94ffa718f33057f560f5795de4cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b43a3890f6c05809d474a0c6ae0e8143f8c2ff23725331dbd7f67cdbd7e23474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f063d1e9a04886639ecf0bd9d603b7218475a12310dea136fa3ac740af0a8475"
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
