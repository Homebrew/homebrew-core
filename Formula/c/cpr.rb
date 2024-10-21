class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/refs/tags/1.11.0.tar.gz"
  sha256 "fdafa3e3a87448b5ddbd9c7a16e7276a78f28bbe84a3fc6edcfef85eca977784"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "52148bb941bbed4a3e8641a942edfcb73bd2c37ad949a4d21255cdc84e3a8772"
    sha256 cellar: :any,                 arm64_sonoma:  "b4f5ac50892af98014d9536a09fbd84e10ed71fdfa0ff4b2d2a8c13a3cf01f17"
    sha256 cellar: :any,                 arm64_ventura: "62221b4b1f800a1b10f7af4774f00a94219a160e79ecc629aeadbc6b0bfb32e3"
    sha256 cellar: :any,                 sonoma:        "e429dd6fc464ef789d5ab13fedd4213266cf1c082319a69647d6cbd70d18c2ca"
    sha256 cellar: :any,                 ventura:       "28de8df1ddca1b9d1c6bf5c3de5978e311b2a95adde7bb0de4981ff38c39ec9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cc60004b96d225fa1633e79ba527227bbf167b52e30730bbd859ea75c3bb558"
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
    args << "-I#{Formula["curl"].opt_include}" if !OS.mac? || MacOS.version <= :big_sur

    system ENV.cxx, "test.cpp", "-std=c++17", *args, "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end
