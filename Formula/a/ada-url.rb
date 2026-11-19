class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://ada-url.com"
  url "https://github.com/ada-url/ada/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "ed818cfe260ec063e1f1d93fdafca4d158162ba515369bef085adc366a03a41c"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 2
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1a9ed071e9441e02860ee26438dd24823c4e727e49aab0707e4b9060d57569a0"
    sha256 cellar: :any, arm64_tahoe:       "50637a6585de002177ab5a4a3b824be54d28b485622abdfb9b400e3222da30ec"
    sha256 cellar: :any, arm64_sequoia:     "259334ea083648295078549887b52a9bd92c655602e60292706d92a174e60896"
    sha256 cellar: :any, arm64_linux:       "b2dfedf1862c87e8eb67d285d7cddb3297330ace8920430629c8f6e4fcf0eb27"
    sha256 cellar: :any, x86_64_linux:      "4fb8371533af9a59d29ea10070d669cd35802a52d7d615e52fe9aef4605f9e06"
  end

  depends_on "cmake" => :build
  depends_on "cxxopts" => :build
  depends_on "fmt"
  depends_on "simdutf"

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

  deny_network_access!

  def install
    # ld: unknown options: --gc-sections
    if OS.mac? && DevelopmentTools.clang_build_version <= 1500
      inreplace "tools/cli/CMakeLists.txt", 'target_link_options(adaparse PRIVATE "-Wl,--gc-sections")', ""
    end
    # Do not statically link to libstdc++
    inreplace "tools/cli/CMakeLists.txt", 'target_link_options(adaparse PRIVATE "-static-libstdc++")', "" if OS.linux?

    # CPM/FetchContent args are to allow using our newer `simdutf`
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DBUILD_SHARED_LIBS=ON
      -DADA_TOOLS=ON
      -DADA_USE_SIMDUTF=ON
      -DCPM_USE_LOCAL_PACKAGES=ON
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
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

    system ENV.cxx, "test.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-lada", "-o", "test"
    assert_equal "http:", shell_output("./test").chomp

    require "pty"
    output_log = testpath/"output.log"
    test_url = "http://www.google.com/bal?a==11#fddfds"
    pid = PTY.spawn(bin/"adaparse", "-d", test_url, [:out, :err] => output_log.to_s).last
    Process.wait(pid)
    assert_match "search_start 25", output_log.read
  end
end
