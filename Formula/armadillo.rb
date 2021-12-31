class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.7.6.tar.xz"
  sha256 "fc7933d27aba9bf0965eb52b4794bc44e5a953a125cef8b37c0d2851008e9dc1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "18b987c16800e02edf2b0cd3834eee85fe9ba055186e8ec604cc47760e285458"
    sha256 cellar: :any,                 arm64_big_sur:  "5af633cbad3df5dad7216ae47d9eacad6d305fffeb46dce108509ff7c55648bc"
    sha256 cellar: :any,                 monterey:       "5a985d30e7867f5a55363a353f0d20747d6f1cecb805878b7368216bc3acdd7a"
    sha256 cellar: :any,                 big_sur:        "b1afcd127a614fca3ed16204d83836f432897d7759fb28c7263e3d7a8e24c287"
    sha256 cellar: :any,                 catalina:       "204d6ea2e4b8548e0ad6f7cdaf017415a28edbb4d7ce34a9579b74400a02ff6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faee656526974514d530e22facd10523c64021348d905615b0dea6bb9c476671"
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
