class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://ada-url.com"
  url "https://github.com/ada-url/ada/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "ed818cfe260ec063e1f1d93fdafca4d158162ba515369bef085adc366a03a41c"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  compatibility_version 2
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    manifest_sha256 "7eb2dbe79665c9a983f132ab810c18c5fe1aa937b78df304b57d25342211c9f8"
    sha256 cellar: :any, arm64_golden_gate: "34452472e0262e9289a7fdfaf7bf14733edd8bc4391a01c75c515e1f2dfe4e85"
    sha256 cellar: :any, arm64_tahoe:       "879ac2eb6c51c6854eedafbc76b426ff0d6e5e579c206a6fc594bcb91b88dfff"
    sha256 cellar: :any, arm64_sequoia:     "98097de57a11f7e8a564f62ef54a2077d53eb31a62eccf5cf5fe0f40f744e1fb"
    sha256 cellar: :any, arm64_linux:       "db1c2fec541028d14e14422e05b9ac0e9bbe707de4cf2f4951bef26805c67098"
    sha256 cellar: :any, x86_64_linux:      "d4c7dced78e4e7b1831ec20d4966305a73bd449bcb5a9ec32fbe35740e43a3ea"
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
