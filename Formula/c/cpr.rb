class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/refs/tags/1.14.2.tar.gz"
  sha256 "b9b529b47083bfe80bba855ca5308d12d767ae7c7b629aef5ef018c4343cf62b"
  license "MIT"
  revision 1
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2813c443cf3657848713409377512a1562bddedc87f1e8966c4b262cbf6e5fd6"
    sha256 cellar: :any,                 arm64_sequoia: "6f14508fda6d35e670b7ef0b1d921c8baf38abbf89b36351fef80319924a5071"
    sha256 cellar: :any,                 arm64_sonoma:  "f905603be3eb805b499cefe9b18ebcaa13128335d3a02377ccdf7092bf1ac276"
    sha256 cellar: :any,                 sonoma:        "e7c26d9dd7fd115043749ee4afaa8963e541ea8a2ca7eae1dd914879a1fec5d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dde32c9cbb9f65f9cb216eb8f5faf929cd3097a80d36f1940a93a454a81de7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30fdf2ef6b122f1dfae08299675f5f3b5d11044f0dd3de813d56d6b6effc7044"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl", since: :monterey # Curl 7.68+

  on_linux do
    depends_on "openssl@4"
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
