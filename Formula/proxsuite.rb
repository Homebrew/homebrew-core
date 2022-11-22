class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.2.10/proxsuite-0.2.10.tar.gz"
  sha256 "428833afe3ad6a438adc9c0762066e272adfc3c97a1997a32292f73e06c5365c"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ddedc28df3068b2bb4020e95fd3a8bc6d23be495d3d60e74eb2e5b731e62dd0a"
    sha256 cellar: :any,                 arm64_monterey: "086d4c085dd469801cdf06d6a3ab85ae512b6a770941655f2a29f6472bf909b5"
    sha256 cellar: :any,                 arm64_big_sur:  "599a3002a0b630824182bd00043a9aa0e343af29d226b76afa90c3da65bb932d"
    sha256 cellar: :any,                 ventura:        "e325e348343bfc4330d08af9f8cdd80e07c1431e0407d7c4b126b878093fd770"
    sha256 cellar: :any,                 monterey:       "877757403a2f9dc8ad9045fd78383d9c6121857db0162feeb697ac5d7bc17eea"
    sha256 cellar: :any,                 big_sur:        "31ef9d60e4bfc700041e754d53576431654ee8b403069ca8c04e0e087b0bcad1"
    sha256 cellar: :any,                 catalina:       "fc0ebfe066bfe9f932a5b21bd6d0f6d99004f57974d85c706855a9c0e459315c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c10f559fd87e65e038a6234f2ff3db730312cec5b62830f171e4aa225627755e"
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
