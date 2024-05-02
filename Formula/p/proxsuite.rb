class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.6.4/proxsuite-0.6.4.tar.gz"
  sha256 "fb90a9e45f5bf91659c394b7cfa22f9754bd864798c10a1269d342f6a456a1f3"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4451da6bd69f89a5f83bb0567af74ad82f843d5cad8a5d67f7bd76c26b368ee8"
    sha256 cellar: :any,                 arm64_ventura:  "5d5109b4dca3f8281bfc64c1108e56a352e2168e0174bf39ef0011497284ad0a"
    sha256 cellar: :any,                 arm64_monterey: "27a5940f4680a34c43741302cf933dcf91e20a069f3bf6715b99824895305e59"
    sha256 cellar: :any,                 sonoma:         "9c71e54a7e6daa8f40a64c691a663fb69f31ba229bc2adc45f1d398ec82c3869"
    sha256 cellar: :any,                 ventura:        "65364bb9412094bc2af81df82a35a6857f75fe658c1e074fd4050fb201156246"
    sha256 cellar: :any,                 monterey:       "fa2302012fa95bce0a6ff33d6fd5558c7bc4df0349e94dc23fe01ba17b401c47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee4b6e1fe8ddf45d1b7e52e4604ddf503a3267f7ecf346f41e5f2549ffe44dcb"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "scipy"
  depends_on "simde"

  def python3
    "python3.12"
  end

  def install
    system "git", "submodule", "update", "--init", "--recursive" if build.head?

    pyver = Language::Python.major_minor_version python3
    python_exe = Formula["python@#{pyver}"].opt_libexec/"bin/python"

    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefix/Language::Python.site_packages

    # simde include dir can be removed after https://github.com/Simple-Robotics/proxsuite/issues/65
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{python_exe}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_PYTHON_INTERFACE=ON",
                    "-DINSTALL_DOCUMENTATION=ON",
                    "-DSimde_INCLUDE_DIR=#{Formula["simde"].opt_prefix/"include"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    pyver = Language::Python.major_minor_version python3
    python_exe = Formula["python@#{pyver}"].opt_libexec/"bin/python"
    system python_exe, "-c", <<~EOS
      import proxsuite
      qp = proxsuite.proxqp.dense.QP(10,0,0)
      assert qp.model.H.shape[0] == 10 and qp.model.H.shape[1] == 10
    EOS
  end
end
