class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.2.2/proxsuite-0.2.2.tar.gz"
  sha256 "da72d900c86fe77a1572f4f2866600ef56a63bd72f050206cc0a2c1643c8f185"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2464474a413122a64afea64c2e23d920a24fe66edc4eb36dcb0dd6e996506070"
    sha256 cellar: :any,                 arm64_big_sur:  "781830154cc4c6dc100f7b20a06641e7cb852389aa7279e2a300c66f2cd86d6e"
    sha256 cellar: :any,                 monterey:       "37ee62731b584cdc1438283fba9822670ebfd7d8894d029281feb2a10bdcb35a"
    sha256 cellar: :any,                 big_sur:        "18c14d6929ead1699e72ce4cf763b85df38793031eb2ed05427db34af1eeaf12"
    sha256 cellar: :any,                 catalina:       "a595743bc166973640f03d3122e493811235e0f856d2f91c79a06f03190695f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d58c96fbaed78889aec13e206dbf3e8975a28ab3e18562c13975dc6f5d96ce7"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.10"
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
                    "-DPYTHON_EXECUTABLE=#{Formula["python@3.10"].opt_libexec/"bin/python"}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_PYTHON_INTERFACE=ON",
                    "-DINSTALL_DOCUMENTATION=ON",
                    "-DSimde_INCLUDE_DIR=#{Formula["simde"].opt_prefix/"include"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    python_exe = Formula["python@3.10"].opt_libexec/"bin/python"
    system python_exe, "-c", <<~EOS
      import proxsuite
      qp = proxsuite.proxqp.dense.QP(10,0,0)
      assert qp.model.H.shape[0] == 10 and qp.model.H.shape[1] == 10
    EOS
  end
end
