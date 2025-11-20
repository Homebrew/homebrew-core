class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "75565e2d4cc8e3ce2dd7927f5c75cc5ebbd3b620468cb0226501dae68d8fe1cd"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "50d62e0af3952214f33d8db467c5f0c4680786980d943ce244fafd0d4f7ede67"
    sha256 cellar: :any,                 arm64_sequoia: "2801164edd3675e14fa2bebaa2e34c285153d7c96eb71ab52780689bd464c5f5"
    sha256 cellar: :any,                 arm64_sonoma:  "8c32ecf2d524b6ebb3adf0ec91785c093b78452cc79c299ea7ba20b098a42d2e"
    sha256 cellar: :any,                 sonoma:        "0b11b09bc97b8a30ecb3f0fa016c52ec604959381b6635b96f76e290cb1f9785"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "533d50e0ca2539bc06e6de76a2c1577de99a71b5858dc93a9fe6dc643d8af4c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "688ad78d321118be7aab51c1eccb86540044e4ee83a9eae780d53e9c19f8f26d"
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
