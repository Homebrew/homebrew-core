class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/1.6.2.tar.gz"
  sha256 "c45f9c55797380c6ba44060f0c73713fbd7989eeb1147aedb8723aa14f3afaa3"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1a402921b3872174a202b0e4bbafc68ec6f2631aa6c0594b3f8424970dc0e020"
    sha256 cellar: :any,                 arm64_big_sur:  "6b725644e68fd8fd18ee1624248de28bff8e0c206d566852a4821714fed3099e"
    sha256 cellar: :any,                 monterey:       "6498c70918f4246246eefd7f5cfd4adef5a5f5c2c958a0449d68d514ea530235"
    sha256 cellar: :any,                 big_sur:        "f531320c598e51d6fa215fe35caf9766882349bb1e5d89319ec6a0937202f627"
    sha256 cellar: :any,                 catalina:       "3c3d0ebe3de5371c93a5b1b68b599e9aee2d5abe2e8598a6775b463be05bcddc"
    sha256 cellar: :any,                 mojave:         "608ac5168dd4ca3ab78d84827ccfce0abba0ad9699bef82ffad074a0b51aefc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8de8dbf9435d2d5ed2bf84013134b6387354ae96f0c4ad8b7a8c2597bed20273"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"

  def install
    args = std_cmake_args + %w[
      -DCPR_FORCE_USE_SYSTEM_CURL=ON
      -DCPR_BUILD_TESTS=OFF
    ]

    system "cmake", ".", *args, "-DBUILD_SHARED_LIBS=ON"
    system "make", "install"

    system "make", "clean"
    system "cmake", ".", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "make"
    lib.install "lib/libcpr.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <cpr/cpr.h>

      int main(int argc, char** argv) {
          auto r = cpr::Get(cpr::Url{"https://example.org"});
          std::cout << r.status_code << std::endl;

          return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                    "-lcpr", "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end
