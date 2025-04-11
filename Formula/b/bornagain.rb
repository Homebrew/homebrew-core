class Bornagain < Formula
  include Language::Python::Virtualenv

  desc "Simulate and fit neutron and x-ray reflectometry and GISAS"
  homepage "https://bornagainproject.org"

  url "https://jugit.fz-juelich.de/mlz/bornagain.git",
      tag: "v22.0", revision: "08e72eb7da6677fde2178a7b879686c469fb90b5", depth: 1

  license "GPL-3.0-or-later"

  depends_on :macos

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gsl"
  depends_on "libcerf"
  depends_on "libformfactor"
  depends_on "libheinz"
  depends_on "libtiff"
  depends_on "python"
  depends_on "qt"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/a9/5a/0db4da3bc908df06e5efae42b44e75c81dd52716e10192ff36d0c1c8e379/setuptools-78.1.0.tar.gz"
    sha256 "18fd474d4a82a5f83dac888df697af65afa82dec7323d09c3e37d1f14288da54"
  end

  def install
    ff_cmake_dir = Formula["libformfactor"].prefix/"cmake/"
    heinz_cmake_dir = Formula["libheinz"].prefix/"cmake/"

    # Build a Python virtual environment with the required packages
    venv = virtualenv_create(buildpath/"venv", "python3")
    venv.pip_install resources

    system "cmake", "-S", ".", "-B", "build",
           "-DBA_TESTS=OFF", "-DBORNAGAIN_PYTHON=ON", "-DBA_PY_PACK=ON",
           "-DCMAKE_PREFIX_PATH=#{ff_cmake_dir};#{heinz_cmake_dir};",
           "-DPython3_EXECUTABLE=#{buildpath}/venv/bin/python",
           *std_cmake_args

    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "ba_wheel"
    system "cmake", "--install", "build"
  end

  test do
    test_cpp = %Q(\
    #include <cmath>

    namespace Math {
    namespace Bessel {
        // Bessel function of the first kind and order 0
        double J0(double x);
    }
    }

    int main()
    {
        const double J0_x = 0.7651976865579666E0; // J0(x = 1)
        const double x0 = 1.E0, j_x0 = Math::Bessel::J0(x0),
              delta = std::abs(J0_x - j_x0);

        const int valid = (delta < 1e-12)? 0 : 1;
        return valid;
    }
    )

    ba_test = testpath/"ba_test.cpp"
    File.write(ba_test, test_cpp, mode: "w")
    system "g++", "-std=c++17", "-o", testpath/"test.out",
           testpath/ba_test,
           "#{lib}/_libBornAgainBase.so"
    system testpath/"test.out"
  end
end
