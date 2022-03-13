class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.03.07.00/fizz-v2022.03.07.00.tar.gz"
  sha256 "22e06dbb4860c99306cf64d15bb2ce248678f0747bbe326e78441378f4391c02"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "557f732e8eb5f73420bc41ced6567cc0c2b107a193a9922a1709aab82de86e4e"
    sha256 cellar: :any,                 arm64_big_sur:  "9ac54a04faa56bdb95ff7e20f1f33294c45a4ddc1d22e70dbb4a0c730e2eebf8"
    sha256 cellar: :any,                 monterey:       "949d715b94781bf9394f4991c9b08b6b5e91d48052610addcbbf9ae9df26b1bd"
    sha256 cellar: :any,                 big_sur:        "4d159a7299d73cbb26bc39d450becba06d6134e75b879fd5df104993e0abe852"
    sha256 cellar: :any,                 catalina:       "d50193fa1f7cd11c06f36e39f990cbe07ae863d3d901bdfd8a0af0ac228944df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d5d697f6910beaaea13fb64d6ec30aebfc4aa69ed4135e62f4f3847f3ca2bed"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "zstd"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = []
    args << "-DLIBRT_LIBRARY=/usr/lib/x86_64-linux-gnu/librt.so" if OS.linux?

    system "cmake", "-S", "fizz", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fizz/client/AsyncFizzClient.h>
      #include <iostream>

      int main() {
        auto context = fizz::client::FizzClientContext();
        std::cout << toString(context.getSupportedVersions()[0]) << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfizz",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["libevent"].opt_lib}", "-levent",
                    "-L#{Formula["libsodium"].opt_lib}", "-lsodium",
                    "-L#{Formula["openssl@1.1"].opt_lib}", "-lcrypto", "-lssl"
    assert_match "TLS", shell_output("./test")
  end
end
