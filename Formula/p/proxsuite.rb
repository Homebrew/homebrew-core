class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.6.3/proxsuite-0.6.3.tar.gz"
  sha256 "378d1e8a52ffb8a213ec62c01f8ef1c56bc7e7deb0b7588b91e554504d9e63fb"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9d53b4d4f668a96ad3a886c330bac414f9a441bd3bb21635c3f91bb3ea3023ea"
    sha256 cellar: :any,                 arm64_ventura:  "4724a2e8b02581ce1ac6424e370731f2c4118638e3e5c176b112c2700cc3fba1"
    sha256 cellar: :any,                 arm64_monterey: "4265993681c27284384179d300c215332abda1b6edf514ce97601525db10a05c"
    sha256 cellar: :any,                 sonoma:         "6a253d84acb53edacfb859b78d71a5e1ce4ec2e8d606d6e2e25d53658c5ad097"
    sha256 cellar: :any,                 ventura:        "60cd2445d78f1184db55a523c4a0a62588b5de77e77f207f366acae1ddd6d353"
    sha256 cellar: :any,                 monterey:       "707d07d242f274aa5e0f0e775d082151be9e220c7890fb093d2ff134c7cd3184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db4b850d22efeb42c00764cac26b8dd0c38dff204df5dffeff0ae14d9e5480cc"
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
