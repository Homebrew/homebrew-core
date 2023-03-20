class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/1.10.1.tar.gz"
  sha256 "dc22ab9d34e6013e024e2c4a64e665b126573c0f125f0e02e6a7291cb7e04c4b"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8de164388ffbf11b113b9c5fe233249c21acdd862c3d28b82d9010fcf9cf61b0"
    sha256 cellar: :any,                 arm64_monterey: "b7bdeb4299cac576edfd74f1bfd2cb261d61a46802d0f5f45d82ff7c382d5c88"
    sha256 cellar: :any,                 arm64_big_sur:  "e361052b91de21b37ff4fd7c2002fb0bd36d3828a5e7bf113138566bb1c75c88"
    sha256 cellar: :any,                 ventura:        "37ff99e818fd2034c6f31cc346b91dc659fe500e0a9c9c56dc27dd9de0fbb890"
    sha256 cellar: :any,                 monterey:       "1ec2d9da6b8c17740c561d9ea92da1689517e3af08875e7183aa14d17a8ee0fb"
    sha256 cellar: :any,                 big_sur:        "967e18a037d91f5c4e8833a654a919e6d4443e5f9465360f8b154e5f5b21419e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0028ce9198459ed30456c69bc5378456d5410d921fc7b85fa321bfbb2852442b"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl", since: :monterey # Curl 7.68+

  on_linux do
    depends_on "openssl@3"
  end

  fails_with gcc: "5" # C++17

  def install
    args = %W[
      -DCPR_USE_SYSTEM_CURL=ON
      -DCPR_BUILD_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ] + std_cmake_args

    ENV.append_to_cflags "-Wno-error=deprecated-declarations"
    system "cmake", "-S", ".", "-B", "build-shared", "-DBUILD_SHARED_LIBS=ON", *args
    system "cmake", "--build", "build-shared"
    system "cmake", "--install", "build-shared"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *args
    system "cmake", "--build", "build-static"
    lib.install "build-static/lib/libcpr.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <curl/curl.h>
      #include <cpr/cpr.h>

      int main(int argc, char** argv) {
          auto r = cpr::Get(cpr::Url{"https://example.org"});
          std::cout << r.status_code << std::endl;

          return 0;
      }
    EOS

    args = %W[
      -I#{include}
      -L#{lib}
      -lcpr
    ]
    args << "-I#{Formula["curl"].opt_include}" if MacOS.version <= :big_sur

    system ENV.cxx, "test.cpp", "-std=c++17", *args, "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end
