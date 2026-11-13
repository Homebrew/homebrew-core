class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "8bd4818895e66784c7f86e73997df4f9b318a9b06c233798f9ec169776656e07"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "40b5d7935c4a53416e33744f669279824559f0149125c0f29d718882008a4e37"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "233a6486d36942c9e72878a6b81381c6e0e7fb035514fd8b54c54ab990110a9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2bb324498cb2a017885c6c7b0b94dfc7e1b101e6017cba6290998cada7554a80"
    sha256 cellar: :any,                 arm64_linux:       "1491f5742a385d95248eaf7bffd36b11baa34cdcc7d750d9fb03d4df001be66d"
    sha256 cellar: :any,                 x86_64_linux:      "a6ae06fbab97a98e0961fa4d64f38f09ee3d218ec0cf709ebe5c649c26c66b4c"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "nanobind" => :build
  depends_on "pkgconf" => :build
  depends_on "cereal" => :no_linkage
  depends_on "eigen" => :no_linkage
  depends_on "numpy" => :no_linkage
  depends_on "python@3.15"
  depends_on "scipy" => :no_linkage
  depends_on "simde" => :no_linkage

  resource "jrl-cmakemodules" do
    url "https://github.com/jrl-umi3218/jrl-cmakemodules/archive/refs/tags/v2.4.0.tar.gz"
    sha256 "1e810d43d471e9a172458187fd5ec0746d3155e173f4fb387e6c7fb56906d359"

    livecheck do
      url :url
    end
  end

  deny_network_access!

  def install
    resource("jrl-cmakemodules").stage buildpath/"jrl-cmakemodules"

    # Workaround to fix error: a template argument list is expected after
    # a name prefixed by the template keyword [-Wmissing-template-arg-list-after-template-kw]
    if DevelopmentTools.clang_build_version >= 1700
      ENV.append_to_cflags "-Wno-missing-template-arg-list-after-template-kw"
    end

    args = %W[
      -DPYTHON_EXECUTABLE=#{python3}
      -DBUILD_UNIT_TESTS=OFF
      -DBUILD_PYTHON_INTERFACE=ON
      -DINSTALL_DOCUMENTATION=ON
      -DJRL_CMAKEMODULES_SOURCE_DIR=#{buildpath}/jrl-cmakemodules
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
