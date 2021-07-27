class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.6.1.tar.xz"
  sha256 "1d06c3237d65c7bc461ea12f4fdfd8b5a69b6a965b4900ae70960ce92088179f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "797389e5e5a213eec7661c3827fc63613cc4d9f8ab74fae22761a57bcd101af9"
    sha256 cellar: :any,                 big_sur:       "9937d6dc3d66446f9c6c5bcb71ca18b9767b691c175991aba73a4359631c692a"
    sha256 cellar: :any,                 catalina:      "7aa6135472c7a8c23211279d50f2291f693eb0c86b57bfaad8987e82c7703786"
    sha256 cellar: :any,                 mojave:        "dd17f5fb9b42e4c583c9dae41058e22ef0589b9718231171ddb132f573cbbb42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e54f80c943843a7abe7473f94732e8ac3455999be3f422f4f24ad4ec8d77319"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "openblas"
  depends_on "superlu"
  depends_on "szip"

  def install
    ENV.prepend "CXXFLAGS", "-DH5_USE_110_API -DH5Ovisit_vers=1"

    system "cmake", ".", "-DDETECT_HDF5=ON", "-DALLOW_OPENBLAS_MACOS=ON", *std_cmake_args
    system "make", "install"

    # Avoid cellar path references that are invalidated by version/revision bumps
    hdf5 = Formula["hdf5"]
    inreplace include/"armadillo_bits/config.hpp", hdf5.prefix.realpath, hdf5.opt_prefix
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <armadillo>

      int main(int argc, char** argv) {
        std::cout << arma::arma_version::as_string() << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal shell_output("./test").to_i, version.to_s.to_i
  end
end
