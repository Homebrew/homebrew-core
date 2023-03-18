class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.3.6/proxsuite-0.3.6.tar.gz"
  sha256 "b318bd02c8a5ae45c32589a2abd530a74810a9001cb33b76ab733dc2a3715510"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "730c5427aea9dae3299776fdd775f19eb2ed8a3c4708ca4138bb0b2bc7c74b0a"
    sha256 cellar: :any,                 arm64_monterey: "5eb09ef997de82d56951ce63735083b0c3c80505408f6d80271ff76c363f7175"
    sha256 cellar: :any,                 arm64_big_sur:  "4c401c7e4aa3ea520bcdd7de37ee38139033dbc2935cee72b3246caddd6e397e"
    sha256 cellar: :any,                 ventura:        "3534f41e2c44635a4e38283b2b1eb065b05f5c6ff34311dcece1dd357c9de03b"
    sha256 cellar: :any,                 monterey:       "f786a06707247f4b4872ed1165cbef9b173dcc8e342d18ecd07ff18350799820"
    sha256 cellar: :any,                 big_sur:        "9ab710f28d9bdc5804dcc83970526595defdcdcacbc8366184067324fb1bff4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e63600358d4e6d30148a4c80fa8d7575fd255dc4b8cb1b3711a9731560b0fb6c"
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
