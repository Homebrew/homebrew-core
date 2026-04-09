class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.7.2/proxsuite-0.7.2.tar.gz"
  sha256 "dedda8e06b2880f99562622368abb0c0130cc2ab3bff0dc0b26477f88458a136"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "devel"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2912fb63e15581feb0bb390fd5ed3e525c46bcb7b6781d12bd813dfe6282ce59"
    sha256 cellar: :any,                 arm64_sequoia: "493ab8fd75c3da238ccf667516e248abfde1a8feb04ab5a6ce6813c7f35631ad"
    sha256 cellar: :any,                 arm64_sonoma:  "d0484ed787682b90d87bfb5bb834b88e68ea04ac9d9fed36f27defa821469225"
    sha256 cellar: :any,                 sonoma:        "3ff24000da0064252d189835999b4775042709339922ac3891c75c7201a91a08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "696c5bd08330dba311f390d3aa3be29016d4d74ebc7d714bf2aee89c31580537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd84dda9a674cf2ff721ce5cd3a2b62d03977601306072a905adec2559de78e2"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "scipy" => :no_linkage
  depends_on "simde"

  def python3
    "python3.14"
  end

  def install
    system "git", "submodule", "update", "--init", "--recursive" if build.head?

    # Workaround to fix error: a template argument list is expected after
    # a name prefixed by the template keyword [-Wmissing-template-arg-list-after-template-kw]
    if DevelopmentTools.clang_build_version >= 1700
      ENV.append_to_cflags "-Wno-missing-template-arg-list-after-template-kw"
    end

    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DBUILD_UNIT_TESTS=OFF
      -DBUILD_PYTHON_INTERFACE=ON
      -DINSTALL_DOCUMENTATION=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
