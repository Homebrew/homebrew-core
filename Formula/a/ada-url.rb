class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v3.2.7.tar.gz"
  sha256 "91094beb8090875b03af74549f03b9ad3f21545d29c18e88dff0d8004d7c1417"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "49e7c96a4cc3c978894c93607aed26e7a0ab64fffb1b8f5725a16ff68a236e9a"
    sha256 cellar: :any,                 arm64_sonoma:  "5a8a2e7c50c06fca1fbc9f6682fd31569cfbe9c5f075ab742cccba39280cb4a4"
    sha256 cellar: :any,                 arm64_ventura: "8b54308b388ce3ae1e417aae2716513faaa77e96d6435b73a136739352d7aad1"
    sha256 cellar: :any,                 sonoma:        "e22d95f05db7451750c0a411522fa57d6c6f67caba6d21ae276a2050a5672ed4"
    sha256 cellar: :any,                 ventura:       "4a0257b458c101fd82a19cc0602fe4cd9a5982142cd596ea191593be7c86d062"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a163000a7fb4c22e53c73bfaca54db8d9dfd99b8c6134b9884e17f5c148387f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b848376037b34315b917afb20f24bd6e1f022918ef2b24f1f891b2790c3d6104"
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
