class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/refs/tags/1.11.3.tar.gz"
  sha256 "0c91cb79b6b0f2ac0cede1acce1da371a61f9aaf3bc85186805d079d68fa026b"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1c9bd5162c8e346f7c56bce41841350703fe3d85100656dcbb59725d1928d2b2"
    sha256 cellar: :any,                 arm64_sonoma:  "8b9dc644c7342b6f6b88e5015ac4dd6a79629b40d6c3e0164b6779cf7536dcfc"
    sha256 cellar: :any,                 arm64_ventura: "bf690d6b07213b482abd6cc719d33ec33a4e46b8eafd4199d5c8ae67b21b364a"
    sha256 cellar: :any,                 sonoma:        "669e88cb4ae3b16714bbb2bc169b6413761b0d1703550995cf406b5c192cd51f"
    sha256 cellar: :any,                 ventura:       "38fb0f418121575c4915c3b050b881588e75a17fa01dfee71a9f7ee011333ef6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "add89b33be121e114ea70c8e22017886980c861ecf209413d374b580fd94fda0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02e287667883c4874417c468ceb379ef4e0f920761cf2252db57f35baae6cc4d"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl", since: :monterey # Curl 7.68+

  on_linux do
    depends_on "openssl@3"
  end

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
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <curl/curl.h>
      #include <cpr/cpr.h>

      int main(int argc, char** argv) {
          auto r = cpr::Get(cpr::Url{"https://example.org"});
          std::cout << r.status_code << std::endl;

          return 0;
      }
    CPP

    args = %W[
      -I#{include}
      -L#{lib}
      -lcpr
    ]
    args << "-I#{Formula["curl"].opt_include}" if !OS.mac? || MacOS.version <= :big_sur

    system ENV.cxx, "test.cpp", "-std=c++17", *args, "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end
