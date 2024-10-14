class Casadi < Formula
  desc "Symbolic framework for numeric optimization"
  homepage "http://casadi.org"
  url "https://github.com/casadi/casadi/releases/download/3.6.6/casadi-3.6.6.tar.gz"
  sha256 "104601d37ab7ebf897bce7e097823bb090dd7629a7cc4c2e76780f46fc0e59f6"
  license "LGPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build

  depends_on "ipopt"
  depends_on "numpy"
  depends_on "osqp"
  depends_on "proxsuite"
  depends_on "python@3.12"
  depends_on "swig"
  depends_on "tinyxml2"

  def python3
    "python3.12"
  end

  # homebrew shim build patch
  patch do
    url "https://github.com/casadi/casadi/commit/81bbcd37d9aa69e53cae7164e5c5c06c5f8529ee.patch?full_index=1"
    sha256 "3322309ba9347756eaf6a61bd4f5fe8b91283d914848f2ff28464215c9e0514a"
  end

  def install
    site_packages = prefix/Language::Python.site_packages(python3)
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DWITH_PYTHON=ON",
                    "-DWITH_PYTHON3=ON",
                    "-DWITH_LAPACK=ON",
                    "-DWITH_IPOPT=ON",
                    "-DWITH_BUILD_IPOPT=OFF",
                    "-DWITH_JSON=OFF",
                    "-DWITH_THREAD=ON",
                    "-DWITH_OSQP=ON",
                    "-DWITH_BUILD_OSQP=OFF",
                    "-DWITH_QPOASES=ON",
                    "-DWITH_PROXQP=ON",
                    "-DWITH_BUILD_PROXQP=OFF",
                    "-DWITH_TINYXML=ON",
                    "-DWITH_BUILD_TINYXML=OFF",
                    "-DWITH_KNITRO=OFF",
                    "-DWITH_BUILD_KNITRO=OFF",
                    "-DWITH_CPLEX=OFF",
                    "-DWITH_MOCKUP_CPLEX=OFF",
                    "-DWITH_GUROBI=OFF",
                    "-DWITH_MOCKUP_GUROBI=OFF",
                    "-DWITH_HSL=OFF",
                    "-DWITH_MOCKUP_HSL=OFF",
                    "-DWITH_WORHP=OFF",
                    "-DWITH_MOCKUP_WORHP=OFF",
                    "-DCASADI_PYTHON_PIP_METADATA_INSTALL=ON",
                    "-DCASADI_PYTHON_PIP_METADATA_INSTALLER:STRING=\"brew\"",
                    "-DSWIG_IMPORT=ON -DSWIG_EXPORT=OFF",
                    "-DPYTHON_PREFIX=#{site_packages}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~EOS
      from casadi import *

      # minimize    3x + 4y
      # subject to  x + 2y <= 14
      #            3x -  y >= 0
      #             x -  y <= 2


      # Sparsity of the LP linear term
      A = Sparsity.dense(3, 2)

      # Create solver
      solver = conic('solver', 'qpoases', {'a':A})

      g = DM([3,4])
      a = DM([[1, 2],[3, -1], [1, -1]])
      lba = DM([-inf, 0, -inf])
      uba = DM([14, inf, 2])

      sol = solver(g=g, a=a, lba=lba, uba=uba)
      print(sol)
    EOS
  end
end
