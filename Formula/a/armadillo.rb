class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.6.6.tar.xz"
  sha256 "3858b0fd431772af032ad3f35c2aeb54e8dabea59169e7d1e9fccd78bc82ad35"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f8e0192b5fad55a44c2a24fc2cbfd255676fab3ac923c0a840b885c773a3b334"
    sha256 cellar: :any,                 arm64_ventura:  "08be7f47b0b5c67c025cabf0ec7013928f3a17c8b2567cd68a002266722b9387"
    sha256 cellar: :any,                 arm64_monterey: "2a25095dd6a3803e4d1aa8a64cc9a34b0636a81b0b95a74dbb56db2b315a8c17"
    sha256 cellar: :any,                 sonoma:         "85c0c0502c2909049522c8532109db79470c9ff5ae7bf914174ce7b9ac9604b4"
    sha256 cellar: :any,                 ventura:        "630a685afe1963d04f37051001229ca18b40f3b7e683027d52f22df8b7cedcbb"
    sha256 cellar: :any,                 monterey:       "e9401f11dc7a968ffe62910d2178ae9d21c8f81ed56557ca6d62e92085373a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75e0269d49c605532c4e3bf8966c0c18ee1e684f34e2ab336e04ff19b73e4a2f"
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
