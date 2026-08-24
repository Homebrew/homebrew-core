class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.4.2.tar.xz"
  sha256 "58fa258d0e1f93074c9afa792027fc259b85cb974ccc0b932b061d4ada5bd83a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "25139dc6b6b7f146d8542e0c3f4bc5b7dd3d6fa9beb3f1f716839693a7103fed"
    sha256 cellar: :any, arm64_sequoia: "1f810af29c45b98c56849a45b88917faa3ba1a805b5e59faef2f65b236ba24e9"
    sha256 cellar: :any, arm64_sonoma:  "c976779efecdad9b577c7f7efb78b97edf0dd65f08021cdb732101839007825b"
    sha256 cellar: :any, sonoma:        "fbe493952e173dacc1adb83f535be7b4b7748f4871d982865da82c6bcdbd12d7"
    sha256 cellar: :any, arm64_linux:   "3b372058bda1771b1483253df2f71d24b0e10936e549535807052106821eb9e6"
    sha256 cellar: :any, x86_64_linux:  "1b8b57a92c2532dfa9a6855689c78ecbdcfba57c5bbab069a593b192b53b37df"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "arpack"
  depends_on "openblas"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DALLOW_OPENBLAS_MACOS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <armadillo>

      int main(int argc, char** argv) {
        std::cout << arma::arma_version::as_string() << std::endl;
      }
    CPP
    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal version.to_s.to_i, shell_output("./test").to_i
  end
end
