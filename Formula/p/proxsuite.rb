class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.4.1/proxsuite-0.4.1.tar.gz"
  sha256 "216e99fdd68d0f66ce5193be863c924223146458f4046e5a88ff51b877eb473a"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5adb1de1bd8069fce4e4de5bdd9cb5e9cc8de2b586220d9d9e3e0ce4d06a50bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e51e8294a338f6854b77578fa861b7fe5b6610998691d2b38f3bb605e0e12ce8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8723a091855cbd8cebdeccd4062b1f1f5bc15a4d08eccf86e48e082ff0d28121"
    sha256 cellar: :any_skip_relocation, ventura:        "58cc340da19297afeb9c3c2ffcb3fa870b6fd1eb7e9b2d0c24f91fb3ed0720a4"
    sha256 cellar: :any_skip_relocation, monterey:       "01ef3ed9048b748641703f0b5b6aa3a445b86a4f2442642d0f04d31f8817ea92"
    sha256 cellar: :any_skip_relocation, big_sur:        "9684e243b6b0ff61c625537be564689ad25aeb8d043476dcf920411e696609a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64952f3e319d3f58a315945400cf06157d9496b50ab4b0b4de16806cee4de342"
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
    system "git", "submodule", "update", "--init", "--recursive" if build.head?

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
