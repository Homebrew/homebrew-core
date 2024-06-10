class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.6.5/proxsuite-0.6.5.tar.gz"
  sha256 "1690cc9be9f69932e8cf491698c443ed053b5e7d8796fb37c5265f53b2c66649"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "01b87b60a92410eb73d62a3423b8995ef0c137e9bb8885dfe14b350df65af097"
    sha256 cellar: :any,                 arm64_ventura:  "2db42afb68dd0f0dd5e0172788e10f5e7206885561bc47b9665aa72e80922f4c"
    sha256 cellar: :any,                 arm64_monterey: "326b4d36aea839784d4e1d2a5a43e1332ce4ea1fb3e7c7fb1be4b33f189c5dd2"
    sha256 cellar: :any,                 sonoma:         "a780c0afb765cb77a48dcecc658920c093bcfcbdad3dc84ecc731cbd404309b7"
    sha256 cellar: :any,                 ventura:        "a7955190a7f9797c5ee488167465be392eae77966bf02dee0ff7fb99b6db334f"
    sha256 cellar: :any,                 monterey:       "3b8d607fcadd3414d1c948ad8682bf04d9a89f57f736dad1ef9d5a747fa275a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2c09d968ad1ca12c02447c11fdce84c7d63387c15241fdc1a50fae59df0649d"
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
