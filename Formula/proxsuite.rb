class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.3.2/proxsuite-0.3.2.tar.gz"
  sha256 "011244645ad700bb4ac56de1b24f174e734915991dfc3b0125a32c1f520bde2f"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a0a03cff77aa25290bd4cae9fbdbf2890d1e43de9769cb734c7d655c09c39fba"
    sha256 cellar: :any,                 arm64_monterey: "5bd838a700e01dd0a6d102ee788d18399a6a4fd59e33d694ec28f9c5ed677755"
    sha256 cellar: :any,                 arm64_big_sur:  "de72cf75870cd98ce934925fde3e45f4fa4572744388a8c589cc881a3b25ac2a"
    sha256 cellar: :any,                 ventura:        "58b2f57bff146a0d9d7a120df3413d33ca36234854303dac3a21fdacde1f3b04"
    sha256 cellar: :any,                 monterey:       "3a482de0f67dd7b512b669bdff2743031af7b9c40116f2f14704086b0154f826"
    sha256 cellar: :any,                 big_sur:        "360ca8dc908c8df1f791f1cfee5e4cd027630b3aeeb352e1856f603252008a94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32e6a303b7fdc8cf790f83254c242d418f56eea2a08d03704d41130da88c48ca"
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
