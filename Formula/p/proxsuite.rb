class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.7.0/proxsuite-0.7.0.tar.gz"
  sha256 "4c06393ed0db6a2633261b3f634d22f7dd824d19087c427f77d0d7a97665feb1"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "98e52f4a4382d23c457305f3223d2d6c10213f5f520408d972fa870c9d715d28"
    sha256 cellar: :any,                 arm64_sonoma:  "17e2bf24ff25a59f368cbb0e0814539c377b2019494817c303d3585a531ecd8d"
    sha256 cellar: :any,                 arm64_ventura: "a31ae867d19011a52bf67f8aba8105e166420a3ca7c3079aaff49dfa49a7c22f"
    sha256 cellar: :any,                 sonoma:        "c017387443d36d1458b3cdcc0507cb22e62523208b7f8074f66786d4ebc11646"
    sha256 cellar: :any,                 ventura:       "4731b3eb108d5f477b5b77712c3230b9626368780fb9b107334eea8fd7c0addb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e07332533c6419b3e10c0d1f8a970097d09bd83f02782483085b336976b606c"
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
