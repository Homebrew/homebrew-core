class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "b9b05f29d30f69cf90853ae1f7015914b5e371a6dac6aa46630aaa090447c578"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a3a54b842a94e0fb112186d0f385f59b7ea058d7cd3fa807acf3e9a28a2d2f7b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75c50abafc996878a2f040b76c962747619a768e21437ee07afc52fe04cad184"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f53ed102974ae5419a0eb7aa82c50cafa1c22fa7891d76d822e93d25f7685843"
    sha256 cellar: :any,                 arm64_linux:       "e070159e01436b7a2ef644d9ec7c503f5325f896db6a2c0af81f6b1b6f4f3838"
    sha256 cellar: :any,                 x86_64_linux:      "f9d57abed889ff83f7622a585467159860787915935accbbf9b29ee60e2da937"
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
    url "https://github.com/jrl-umi3218/jrl-cmakemodules/archive/refs/tags/v2.3.0.tar.gz"
    sha256 "840cfba922b9589695ee3da4da3f9472ceeefe8fe4bccbb7ed3e885d1ca978cf"
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
