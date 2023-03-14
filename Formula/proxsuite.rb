class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.3.6/proxsuite-0.3.6.tar.gz"
  sha256 "b318bd02c8a5ae45c32589a2abd530a74810a9001cb33b76ab733dc2a3715510"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c02489750f2bd5a5dc8b7e3af36e105c6daa37183c364e1ce9a210fb535e4670"
    sha256 cellar: :any,                 arm64_monterey: "7cc145728784e80b26befedf1f94d9529ed8dd6bfda733bce3ee9f408161e1cc"
    sha256 cellar: :any,                 arm64_big_sur:  "9e800e46087f44a47ce8f1c8af4ac8c88ee594ce327b55d42ad2c40827204dca"
    sha256 cellar: :any,                 ventura:        "3c63c13b28d33ec1db520523816e9d92842d9d6b65dcb4761c152bd1457b4ae0"
    sha256 cellar: :any,                 monterey:       "dc26e8c7eb3d3b89c84802bbac2e51b97dacafa14d347d0a9d9b4928acdc7f21"
    sha256 cellar: :any,                 big_sur:        "a7c92615f83625f175381033a65f73689bff37e94a676676a771acc75c299ee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf0b01b596ddd98a4b78604448ce9f0b27b1d81e87855137e0d724da3f780b12"
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
