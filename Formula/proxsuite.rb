class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.2.7/proxsuite-0.2.7.tar.gz"
  sha256 "00422c0cd5f1f7c72a5f76b1373937dcc40a74546194e04cf027abb6064bdd59"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6de903ae15eaa5e7c9ff864bb6a748b0f7c654ec3447f7e28a9761f6d621e281"
    sha256 cellar: :any,                 arm64_monterey: "b6d2cdf61364e820b9ab0ca7ed56d5b136e9925e6eaa9ce48821e986fac850bd"
    sha256 cellar: :any,                 arm64_big_sur:  "5da1f1618ba3d8cfeae71fed9e38ee262fe72a1d7a4a5ba408d8c8556559cc37"
    sha256 cellar: :any,                 monterey:       "79bb4390c617f3aec24b194e2d3ec9905caa584c8687244b4807fc65ede13ac5"
    sha256 cellar: :any,                 big_sur:        "9da5dd13b35777015ea7c85c445998ab89780cfa4a104547d4895574df54cb5b"
    sha256 cellar: :any,                 catalina:       "17100e23f3b9c77a3be3ab93bbe1057511af3da86c0d2b36f15cca2f78d6f90f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "951cee43e7def785094c04e3ff5121697327fb6abcd6fa826b18b0f8862c9439"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "scipy"
  depends_on "simde"

  def install
    if build.head?
      system "git", "submodule", "update", "--init"
      system "git", "pull", "--unshallow", "--tags"
    end

    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefix/Language::Python.site_packages

    # simde include dir can be removed after https://github.com/Simple-Robotics/proxsuite/issues/65
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{Formula["python@3.11"].opt_libexec/"bin/python"}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_PYTHON_INTERFACE=ON",
                    "-DINSTALL_DOCUMENTATION=ON",
                    "-DSimde_INCLUDE_DIR=#{Formula["simde"].opt_prefix/"include"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    python_exe = Formula["python@3.11"].opt_libexec/"bin/python"
    system python_exe, "-c", <<~EOS
      import proxsuite
      qp = proxsuite.proxqp.dense.QP(10,0,0)
      assert qp.model.H.shape[0] == 10 and qp.model.H.shape[1] == 10
    EOS
  end
end
