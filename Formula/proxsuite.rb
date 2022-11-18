class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.2.10/proxsuite-0.2.10.tar.gz"
  sha256 "428833afe3ad6a438adc9c0762066e272adfc3c97a1997a32292f73e06c5365c"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c6928c82258f7bd58f6c5957595acfa9bc619f6899be453553fc62312753e1c3"
    sha256 cellar: :any,                 arm64_monterey: "38e91aedb35f4be5da83982db7c23d70f27a865ea0955790766051bc03dcc478"
    sha256 cellar: :any,                 arm64_big_sur:  "3ae512cf53c18eab734fe70f4019c7dba5116644ee768275cce8fa068d428307"
    sha256 cellar: :any,                 monterey:       "9d617460d37cb8816f2a697c8342bb41954032e22568deae8fe7a0c0d2e9b6fa"
    sha256 cellar: :any,                 big_sur:        "72e4d8dfed5699c61f74bceb7b6c29c8782c31e4159d8772bddf3520c170959b"
    sha256 cellar: :any,                 catalina:       "58c924a51be16350727764d428967d8c72addfb515ea8c0942723523c95870b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3f5bae08eac52cec7cf0e2e7d8011f33a0e775c12a20f7f9b42708b965d36b9"
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
