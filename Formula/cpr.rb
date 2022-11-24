class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/1.9.3.tar.gz"
  sha256 "df53e7213d80fdc24583528521f7d3349099f5bb4ed05ab05206091a678cc53c"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3d89c9f4c3a1f0d50061bb0d9e364c0a2f174838c59103cd14d42187b4ab5c92"
    sha256 cellar: :any,                 arm64_monterey: "752288ba540fcaa1ea6b47831e09c3ce78ecd283d40e26f6a98d568290f986f4"
    sha256 cellar: :any,                 arm64_big_sur:  "1e67a99589b9982c3dc91bc5df39f267654b0b29822e3dc4a8c6104ead17bd2a"
    sha256 cellar: :any,                 monterey:       "e24ba09f09581bdf741d456c117ad15f849bbd1bc67cc32c4939aa3e70285657"
    sha256 cellar: :any,                 big_sur:        "705b7c7e54ed69658f7f02380463e98d256ada5c702fb48a878c6faac02d1aea"
    sha256 cellar: :any,                 catalina:       "563fd6e0e3de0de716825fdceba92a773a5ce2c8628aa17b22ed0c246f7a0c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebc12ceb882207930633621c798e248565d8abd5e57da80485907ba44b4e905d"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    args = %W[
      -DCPR_FORCE_USE_SYSTEM_CURL=ON
      -DCPR_BUILD_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ] + std_cmake_args

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
