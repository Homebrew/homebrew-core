class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.2.7/proxsuite-0.2.7.tar.gz"
  sha256 "00422c0cd5f1f7c72a5f76b1373937dcc40a74546194e04cf027abb6064bdd59"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "117cc7252d42c8b51a7649976b45fd9c58101de4af0af5907a08a229ca282490"
    sha256 cellar: :any,                 arm64_monterey: "52a97b825f5aa58b0a4263fd0b91b023777925a3bd503798cb7f89796f1ee38a"
    sha256 cellar: :any,                 arm64_big_sur:  "696fef5c6e157104eaa1a45001cd1500338b99b9b84fde036905093eac21ed84"
    sha256 cellar: :any,                 monterey:       "62530c8b28949a52e93ce8cdf365ac6ef0be93cda08805f6fcc0922339b8923d"
    sha256 cellar: :any,                 big_sur:        "f6270ec794432e81b3a9fe629f53fae78eaecb0434bd50e74a05bf59daf4fced"
    sha256 cellar: :any,                 catalina:       "e4493dcf6eff8753517dc4dd9b953a56de4257b80bfb4d5ad3c4df45ce87cb9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e64a287169b95ccb469424bec687093c9673c2dabdab1b33870f6d78781f544"
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
