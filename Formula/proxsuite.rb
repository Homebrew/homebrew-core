class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.2.8/proxsuite-0.2.8.tar.gz"
  sha256 "e1b0c9984530f2353e6360a4e6a90055039fd0887f0e48090821180ce9ccb38f"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e315ecc20d6e09ccb182e53a5e98b268f070293fa42980b216628939188990ad"
    sha256 cellar: :any,                 arm64_monterey: "00d8a59b200c864287719df3dee7cdfd5edfb53b98c25db17ce887f9883cfa1f"
    sha256 cellar: :any,                 arm64_big_sur:  "92364b0bff86a1c4e35f94ad3b50f429eef50d08cce82ec17c3c8dd911ba94d0"
    sha256 cellar: :any,                 monterey:       "6f49649a7fb936d4b723021b7d1cdd5038ab82bb1641a5fbc4f1fc7202840bb6"
    sha256 cellar: :any,                 big_sur:        "3e63c691925b5772e32b3b82c42a5a519a12722d8fb7fcd006895ad07cca99f0"
    sha256 cellar: :any,                 catalina:       "762798aeb76c0dbce04877e0acb5df0a4cb722f5de9d450f77c0f212600c411c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bad4e3f5be459df239766df8463cc6a0bb6375d935fc78bc5d22c1ff40135636"
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
