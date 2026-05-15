class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "77bc5bbc383ed098cc60266ad6ee912de2431bb62d89248c0e17c4e712dcdaf9"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "14bf3540eb0d168084ff5e748077717f2824badf4697205a2f13135070b1816f"
    sha256 cellar: :any,                 arm64_sequoia: "9e9b542074a36db6482d9d1d39c191c5410786e5bd3bec1be69489414d958f2f"
    sha256 cellar: :any,                 arm64_sonoma:  "5cb45c0688bcfbd6d0fbbde936835b6a8ce35974373a40a25e0d3253bff89bbf"
    sha256 cellar: :any,                 sonoma:        "af4c7c480558d2a2d941857296529606f8c921437df78d66311d0f4878de7cc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9b870b4f77920e0d5ed1c9d4960085b89d846597819e6e298aeeb3c9d0f151a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e39841ea7a82f8acf968d7583c332014eeb202396fe23864ed6eb127e727509"
  end

  depends_on "cmake" => :build
  depends_on "cxxopts" => :build
  depends_on "fmt"

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
    # ld: unknown options: --gc-sections
    if OS.mac? && DevelopmentTools.clang_build_version <= 1500
      inreplace "tools/cli/CMakeLists.txt", 'target_link_options(adaparse PRIVATE "-Wl,--gc-sections")', ""
    end
    # Do not statically link to libstdc++
    inreplace "tools/cli/CMakeLists.txt", 'target_link_options(adaparse PRIVATE "-static-libstdc++")', "" if OS.linux?

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DBUILD_SHARED_LIBS=ON
      -DADA_TOOLS=ON
      -DCPM_LOCAL_PACKAGES_ONLY=ON
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

    if OS.mac?
      output = shell_output("#{bin}/adaparse -d http://www.google.com/bal?a==11#fddfds")
    else
      require "pty"
      PTY.spawn(bin/"adaparse", "-d", "http://www.google.com/bal?a==11#fddfds") do |r, _w, pid|
        Process.wait(pid)
        output = r.read_nonblock(1024)
      end
    end
    assert_match "search_start 25", output
  end
end
