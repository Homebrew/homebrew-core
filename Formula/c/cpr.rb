class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/refs/tags/1.11.2.tar.gz"
  sha256 "3795a3581109a9ba5e48fbb50f9efe3399a3ede22f2ab606b71059a615cd6084"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "71b2c9813a08b665d0a5b8b24868396208e09e7bf76cd45c2076d37b99cb6cdc"
    sha256 cellar: :any,                 arm64_sonoma:  "f6a28ce2ce192505511c292fa90858d22d8e42f64ff95c8975cfadc256dcb592"
    sha256 cellar: :any,                 arm64_ventura: "3271fe9f057e55db84d65544aff6b517a8da692ed1c32cf82de0ee7652218fda"
    sha256 cellar: :any,                 sonoma:        "cdaa14c8143c2a06e71b5de2c4f11b997e154924421a099a04dc1170262731fe"
    sha256 cellar: :any,                 ventura:       "12d3ddfced34a20c53564923df2382be1ddd69b605c2d2840781f91ddb6f228c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "929fb7a7d06f35f49c3d30fdc749633bb22d4f7bbb4f83a38b20a066acf884e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a456aa6d23a7639a658cd46e80479bce9889e4a708a0f4e90ed1ed41d2ab63cd"
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
