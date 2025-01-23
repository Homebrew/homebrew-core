class Kfr < Formula
  desc "Fast, modern C++ DSP framework"
  homepage "https://www.kfrlib.com/"
  url "https://github.com/kfrlib/kfr/archive/refs/tags/6.1.1.tar.gz"
  sha256 "71ee9f807e0c6d3cc63740ffee681fa82110ab7eaf524360e9e40ef8e7cda91c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7cc6aeb32e1b1ad06f52669ec74436daa6eddb7732bbd3364eba40c27106ecb8"
    sha256 cellar: :any,                 arm64_sonoma:  "509fe58ecc4ae245c0afd291344fb77a60d37651d0a3c786a2e3d0f697a5c625"
    sha256 cellar: :any,                 arm64_ventura: "7353e642b188ab2babeb95a7cef3e3497e63c3af057b43ef969e1315f8da7121"
    sha256 cellar: :any,                 sonoma:        "273b4590a88e6195ffad107feeb0b97fbd2846b015b0d7540c92d9b7c82a0e5f"
    sha256 cellar: :any,                 ventura:       "93a339ae3ee2bcca825ac1573c6c800963250006326a0482189c6cbbbde704d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25212b3b17ae87f4b329609dbc412d1ec72898f7681dba9de78fe18a60365af7"
  end

  depends_on "cmake" => :build

  def install
    args = []
    # C API requires some clang extensions.
    args << "-DKFR_ENABLE_CAPI_BUILD=ON" if ENV.compiler == :clang

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <kfr/io.hpp>

      using namespace kfr;

      int main() {
        println("Hello KFR!");
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-lkfr_io",
                    "-o", "test"
    assert_equal "Hello KFR!", shell_output("./test").chomp
  end
end
