class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v3.2.7.tar.gz"
  sha256 "91094beb8090875b03af74549f03b9ad3f21545d29c18e88dff0d8004d7c1417"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "32ec226a8abf1d5fe81d4e9b4ea207af0e6faac5473820ddbae67ff09619bec7"
    sha256 cellar: :any, arm64_sequoia: "efa1ad50cbbefa23cfc229055732e22cef47900b66fa3578624dd15b7ca12110"
    sha256 cellar: :any, arm64_sonoma:  "2da93d743e1bb7e2b2c73e54e6a4e55704d5df75b93b0bcc698545fc4ef05b99"
    sha256 cellar: :any, arm64_ventura: "2c6cbed3dd1e562fb171721fd77311d4162a7132fbc75a97b685c4d990d8a2e1"
    sha256 cellar: :any, sonoma:        "958d8a4bfc0bb863c878c4d7cfcc47004e8273d415fd66eddff8b49ad2a46180"
    sha256 cellar: :any, ventura:       "c614d293847ad99afbf94ae4615e28c3f5c5e42b769f8801b589375f6c9c928b"
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
    if OS.mac? && DevelopmentTools.clang_build_version <= 1500
      ENV.llvm_clang

      # ld: unknown options: --gc-sections
      inreplace "tools/cli/CMakeLists.txt",
                "target_link_options(adaparse PRIVATE \"-Wl,--gc-sections\")",
                ""
    end

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DBUILD_SHARED_LIBS=ON
      -DADA_TOOLS=ON
      -DCPM_USE_LOCAL_PACKAGES=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++" if OS.mac? && DevelopmentTools.clang_build_version <= 1500
    ENV.prepend_path "PATH", Formula["binutils"].opt_bin if OS.linux?
    # Do not upload a Linux bottle that bypasses audit and needs Linux-only GCC dependency
    ENV.method(DevelopmentTools.default_compiler).call if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

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

    assert_match "search_start 25", shell_output("#{bin}/adaparse -d http://www.google.com/bal?a==11#fddfds")
  end
end
