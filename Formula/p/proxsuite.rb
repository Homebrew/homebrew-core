class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.7.2/proxsuite-0.7.2.tar.gz"
  sha256 "dedda8e06b2880f99562622368abb0c0130cc2ab3bff0dc0b26477f88458a136"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "55eeaba27c0759020f1af4fee87c57cd7f06250654985fcb314aafd65bd94bc2"
    sha256 cellar: :any,                 arm64_sonoma:  "039089b526b129afda357462b2c41773e3a711ba40cfd5570cdfa97265e3bd8e"
    sha256 cellar: :any,                 arm64_ventura: "bd8a4c2c6c377eddc448910028a0afde9db6185a77c4bcf600191384c6529eb6"
    sha256 cellar: :any,                 sonoma:        "03ca17384128ebc8d2b88b241ccb12947e808186bc52fe15b84499953172bfe7"
    sha256 cellar: :any,                 ventura:       "a09b9bbd5e73a56ca6b74b63e278a434adcd3d93d3fd3502dfdbb55e72526212"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9125d101cc2a36b0d25ace483151f343264097ad3e30612e0262ec3e7016e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57b4ac4f02b44ae31592270e00b6119b22be2e99d685b2d7981cb9b02820eb06"
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
