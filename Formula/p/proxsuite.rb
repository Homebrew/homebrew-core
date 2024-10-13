class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.6.7/proxsuite-0.6.7.tar.gz"
  sha256 "3a397ba96ddcfe5ade150951f70f867a3741206a694e50588f954a94c4cf3f27"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "23034630476e74271706b395357d46ec16bb3b90a1370839629724ee3fda27de"
    sha256 cellar: :any,                 arm64_sonoma:   "ca70c376b0a3759a4c95571c61fdcbd1ff793cef20457572fdd08cd622594a82"
    sha256 cellar: :any,                 arm64_ventura:  "3e6bf30c36a80f68ddbbf9ad638bc1ea4a2326584f90d6ac2b29308b475e1674"
    sha256 cellar: :any,                 arm64_monterey: "0726349c4172e3a0d03ca44be63ee8feec13999dd139d213f9da3ade150bcc89"
    sha256 cellar: :any,                 sonoma:         "46455dfe6c6ee2701940b4e2a829810730d3ffe341e8e5172e7373f6c81ede73"
    sha256 cellar: :any,                 ventura:        "bb01853666ccb2f5333133972e86ff6f80be0f5925bfec9339b6c6cd3d43022b"
    sha256 cellar: :any,                 monterey:       "978d86948711a81e3418af1386b9837bf065c2f7725bbe9281e763d8c821df8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adf28af671df40fef0c8f9ee27812ae8778c669f6b5fc580711b18963ef00000"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "scipy"
  depends_on "simde"

  def python3
    "python3.12"
  end

  def install
    system "git", "submodule", "update", "--init", "--recursive" if build.head?

    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefix/Language::Python.site_packages

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_PYTHON_INTERFACE=ON",
                    "-DINSTALL_DOCUMENTATION=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~EOS
      import proxsuite
      qp = proxsuite.proxqp.dense.QP(10,0,0)
      assert qp.model.H.shape[0] == 10 and qp.model.H.shape[1] == 10
    EOS
  end
end
