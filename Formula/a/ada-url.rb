class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "2eb3d3d7bd2e0c74785f873fc98cf56556294ac76532ef69a01605329b629162"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "91ecce06f5531db27bc1080cd90fabe4ad070d4e3290583d0f636ac4c6cd196a"
    sha256 cellar: :any,                 arm64_sonoma:  "06dde62ca84439c914713f33e0b8514208355c993da3d5288aadb50836950375"
    sha256 cellar: :any,                 arm64_ventura: "6937030f7b6bff468d00aa80c2fb70de12357fb085782fce5713ed11e48aacd9"
    sha256 cellar: :any,                 sonoma:        "9c48c30feb9da2acf835cfaae7c6afe1ecef6185f723e6c7e8f0c178dba82009"
    sha256 cellar: :any,                 ventura:       "2a02af1167afa0a411331e94d0680ba734c84669e2fe903d02dee01afc40c9cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9605bfda161c26d00d45608e3311e2e850d59f445de1f2f8fbad11b2f67f4303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b1b05cb6cf863276cf097c42c6b95c0c38f9612a615cf6815013b413ece035c"
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
