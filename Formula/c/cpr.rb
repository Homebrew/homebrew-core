class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/refs/tags/1.12.0.tar.gz"
  sha256 "f64b501de66e163d6a278fbb6a95f395ee873b7a66c905dd785eae107266a709"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "09b831bfeb3f9574473d0389d56c54a98d6114401fc2461a459b81fae35441b7"
    sha256 cellar: :any,                 arm64_sonoma:  "62774379c35c472b5ce32cd7a1044201f746fde63b6caa1fa0ca1aa6f063ceba"
    sha256 cellar: :any,                 arm64_ventura: "1daf2a4ac0df3bde82610f88f16d84dbb470e5bcd5466376500d43b43fc14997"
    sha256 cellar: :any,                 sonoma:        "6c4d6d71ee53bbe0ba524f3c91c00c33dd3256ac7f36ce5f66735d07203b8fc9"
    sha256 cellar: :any,                 ventura:       "444ed2abda55e8ddbed0ae3f2baf2dd1c90828a158e96f8dbcd7b40288a68fc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce24deaf7cfd5c547c270bd903be2d12afb258dcd140938c1b27a98474bce2ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4986278145e9f1ba77fc0caff4fe08c91437e40cd7b18114cf4d44ba6dbe06e7"
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
