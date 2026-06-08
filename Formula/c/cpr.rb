class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/refs/tags/1.14.2.tar.gz"
  sha256 "b9b529b47083bfe80bba855ca5308d12d767ae7c7b629aef5ef018c4343cf62b"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0f3e8ed113b1279c1128726e802fc8ae395195b2a0d3f730503234056b393fa"
    sha256 cellar: :any,                 arm64_sequoia: "a98d8951a3f0155093e1378fff9b44279958871c18a1832f19e91d573572682d"
    sha256 cellar: :any,                 arm64_sonoma:  "e5f8c5c9bf4f844e78fdde1720e3251d62e39f2ac3927bae55df110e88898979"
    sha256 cellar: :any,                 sonoma:        "e2c8046007a51247012c7243e18324ee09571a5f88dfe62abfc8729c53cf6d9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67ed191360edc4aefc104c06fc5149be59c234fbdf2ee636ae1f92f1a67d877f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75cf39467eb0f010d6c26ccd5b09fe2a1da6b6a00b75bce3287c1004f2c98b63"
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
