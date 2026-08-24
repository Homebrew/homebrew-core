class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://ada-url.com"
  url "https://github.com/ada-url/ada/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "6d6c7ef7dd2e329320d34eb2ab29ccdc879ee3935af9dfb894a6640e58dc381d"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 2
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e3b125f42e888b49edb6b7a6b65f47585d7740e170d59965ff96a2930e2c58fd"
    sha256 cellar: :any, arm64_sequoia: "06292729cd3fcf7e6b73704be693e10010d8231e54fe26dac091b4f8ee1c547a"
    sha256 cellar: :any, arm64_sonoma:  "150fb2c766f3546b98576ebf04e4eac83cd5f1c6031b21133785f3b9b8228d88"
    sha256 cellar: :any, sonoma:        "27fbcf06b02d39cffbc5187eac0f773feca8cb0bbcfd5492c30b5b3fa974f312"
    sha256 cellar: :any, arm64_linux:   "ad0f4a73faaf785a75220c6e4c9dfd94e411cba5d0edb4680ca949e8f44cac17"
    sha256 cellar: :any, x86_64_linux:  "5d9e6918837a81b750fc65b4f9315e99af2a4d8d31846611b456706adf3115e1"
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

  deny_network_access!

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
