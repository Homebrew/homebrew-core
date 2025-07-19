class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v3.2.6.tar.gz"
  sha256 "2e0b0c464ae9b5d97bc99fbec37878dde4a436fa0a34127f5755a0dfeb2c84a0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3bb7077ce7866a336ac40cb45959c51feee7f0c68c79fb8e90ea3c394695493f"
    sha256 cellar: :any,                 arm64_sonoma:  "4ddddeea6b7dff766c1bbe89bd27a615dcb715dead135541826bd2a8c4a52007"
    sha256 cellar: :any,                 arm64_ventura: "90a53c74cda428539d8b73aa8bbc433db40712e3b31b3c3a3022e0a4a0e9b324"
    sha256 cellar: :any,                 sonoma:        "edc06d7b7bd2d46704146362f36a150d43fbd37628ac85a9ad01225391ba5fe4"
    sha256 cellar: :any,                 ventura:       "c9d7a8bc5030750969e0b202fdadd3980769c60c0e6605ea49aee2dcf03c0e26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10273cd26d07039bea902435321d6a9218be651218db60401040bca9e330c20e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a212d9cde2aa517ddb0c1109fea662e63d24e124b5c3fc467dd488b6408e09ea"
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

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DBUILD_SHARED_LIBS=ON
      -DADA_TOOLS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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

    assert_match "Usage: adaparse", shell_output("#{bin}/adaparse --help")
  end
end
