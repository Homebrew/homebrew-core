class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.2.0.tar.xz"
  sha256 "b0dce042297e865add3351dad77f78c2c7638d6632f58357b015e50edcbd2186"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1508508e88243d77a282c10e1087d90788ede3f0613ffc301fe9f8b0975baedf"
    sha256 cellar: :any,                 arm64_monterey: "ed73851d90edc9abe9a0bf312090776b1c336a64ca9dd1d44537e0b6d1e5eadc"
    sha256 cellar: :any,                 arm64_big_sur:  "c4fdae1a4986c52b8dc88de8bb3d8e405f65806564ad5615439be8a7fe8faed5"
    sha256 cellar: :any,                 ventura:        "e7d746dae81e95db3f2f8ebb111cc3680fbbe4f4eba748d969ab538363c8f819"
    sha256 cellar: :any,                 monterey:       "a5c965a7684ef98dd4ca84647c35dae48a695601759d509bf83632a96f116836"
    sha256 cellar: :any,                 big_sur:        "40af2298fd15b4658522cf7b1f15df40044f2c45c299f75af0ad03a7b480ccf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3f1ddbe09acadacbb576ce30ae2727d5b7351df561c425b5103eda01d53e793"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "openblas"
  depends_on "superlu"

  def install
    ENV.prepend "CXXFLAGS", "-DH5_USE_110_API -DH5Ovisit_vers=1"

    system "cmake", ".", "-DDETECT_HDF5=ON", "-DALLOW_OPENBLAS_MACOS=ON", *std_cmake_args
    system "make", "install"
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
