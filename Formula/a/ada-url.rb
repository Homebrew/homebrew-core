class AdaUrl < Formula
  desc "WHATWG-compliant and fast URL parser written in modern C++"
  homepage "https://github.com/ada-url/ada"
  url "https://github.com/ada-url/ada/archive/refs/tags/v3.2.9.tar.gz"
  sha256 "3f34c6f997486c09a49769d9d659784e56d2fde8cbb3c94f610510fcdc890b4d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/ada-url/ada.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "57433824579ffe724cb750e5b32f3ef93033d9dbe1c6e29ec81e21c322c120da"
    sha256 cellar: :any, arm64_sequoia: "4d420cf8e062813e8afd362ccc93cd12fe73ceaf0c082ac58bc81495d832b9d5"
    sha256 cellar: :any, arm64_sonoma:  "1a6b9fc2494e2897e6415a3c4667e709bfd66f502878714030f49f8f8ecd5bb9"
    sha256 cellar: :any, sonoma:        "69b53bb04351903a30fb4da3b20485e69aa4aff06d29a00453b96915117401c5"
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
