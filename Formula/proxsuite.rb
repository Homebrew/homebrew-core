class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.3.7/proxsuite-0.3.7.tar.gz"
  sha256 "792ad93eede02e9aa18d5c2916b94e8731fae4799f18285ccb5fe7b87dbbfc6d"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6f47ffd455eb29b544d36b265abf1b33b1e50aa3f3c4ea01490fa95581d2b03e"
    sha256 cellar: :any,                 arm64_monterey: "0883d268c4554a05d0f27d62385c46f544389d330871a8eeb5948165e2717850"
    sha256 cellar: :any,                 arm64_big_sur:  "2127db890718609eda8ac47b7ad84c6edda09018eec3af0ed18de85ec17b339b"
    sha256 cellar: :any,                 ventura:        "10505e682046166d2480821ebb812094134a150b99522641c19f91c6a6addf4f"
    sha256 cellar: :any,                 monterey:       "14d7f18a527745fdb9a014fdcffaaf1e4be4820bd151ca9b9939ca59ae907afe"
    sha256 cellar: :any,                 big_sur:        "7138169d08d55cd6b18a56d8b43a78cc7d7a6671072aeb648b0c470c7c8913ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "242ae7a90df94b4d6c6bac799d5ed894be7e275b242ed3a7b3d6db92fafbd88c"
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
