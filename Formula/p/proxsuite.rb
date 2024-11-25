class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.6.7/proxsuite-0.6.7.tar.gz"
  sha256 "3a397ba96ddcfe5ade150951f70f867a3741206a694e50588f954a94c4cf3f27"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "17c4c49ce286bf188e68bf8733da74140789b5cc51da3096ceeb5f70b2dbd0f9"
    sha256 cellar: :any,                 arm64_sonoma:  "4c934f75594487b26c8927880d1196ffdf12afbe728305d676520491843923ee"
    sha256 cellar: :any,                 arm64_ventura: "36c0c84817b158b2ac9ceb2ca30544d39295b61d8d229da7e5305f44fc83d30e"
    sha256 cellar: :any,                 sonoma:        "d099504148402fcfa3060f59b5b65e2459bceed8fa4636bebd0effcc3f8636b3"
    sha256 cellar: :any,                 ventura:       "0e3685e0638e44eda4de48da0530bf20f53d322efa891dc1483dc34353e6c988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97379c1bf25c81521de0438d5b9afe7bbea1bb82526f3fafb4426be161dea449"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "scipy"
  depends_on "simde"

  def python3
    "python3.13"
  end

  def install
    system "git", "submodule", "update", "--init", "--recursive" if build.head?
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
    system python3, "-c", <<~PYTHON
      import proxsuite
      qp = proxsuite.proxqp.dense.QP(10,0,0)
      assert qp.model.H.shape[0] == 10 and qp.model.H.shape[1] == 10
    PYTHON
  end
end
