class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "c7a6450019a326c6a10b144249b03ebea662afb2451d74f06963389fe7707460"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "753d0af5b348fffc968be4e126f087b372c30229b5f70d545b68dbebe06ed71e"
    sha256 cellar: :any,                 arm64_sequoia: "d43e0717e87817cd7bf9589fff330e9e7f1082ac7d4b08b9f32f959021b37e6b"
    sha256 cellar: :any,                 arm64_sonoma:  "1df875f42b8e4805098b3225bd30888d047f5d65dee366ae358e4c2b4765e6e1"
    sha256 cellar: :any,                 sonoma:        "f67e316aa2e08bb92b8471b7b15f1fb1f32a987330b947e3203249b6bfe06339"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34159fd23078f273e1031b8adcbf9b4f415033cdaece0abe0bee8b424e91cb35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a0ae11f98bf7f9330403835969eeba9e4330d1bd9c1d1a2941615f2c6ee492e"
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
