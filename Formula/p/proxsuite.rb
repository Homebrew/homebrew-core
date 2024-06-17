class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.6.6/proxsuite-0.6.6.tar.gz"
  sha256 "29058f833b702231751f4ad16746861de262ce638e5392dd968f2004e1de5ff3"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8204ad594c59c53ac0129d937c87927e46714d7adcfba1e80d47c595aa3f97f6"
    sha256 cellar: :any,                 arm64_ventura:  "2597bc95d1084e2817752e8abeb589ff3718216a02ae580a073dc4e8b2935470"
    sha256 cellar: :any,                 arm64_monterey: "9294a8a4968eb9061629cddb82f7d1fe19906a8a1cdab0f77cfb11674e6fa2b6"
    sha256 cellar: :any,                 sonoma:         "f092371747430d47d3508546da2cf047b50c543d746866ba7642d682f79fa5e6"
    sha256 cellar: :any,                 ventura:        "2d52afc5b49c72114e6195f70607c0e4c53c3b68cde7b9550c85febeeb031955"
    sha256 cellar: :any,                 monterey:       "da926f13dd19e1b7d475dad9126319c7b920d9b29aad29db0ae9b52cf4ed04f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a944e2a40ee3706092d7bb4dd1a8355bedff145072402195e677e8ca60380a7"
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
