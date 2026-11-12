class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "8bd4818895e66784c7f86e73997df4f9b318a9b06c233798f9ec169776656e07"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "213c593f88d799d03e98aec318c61406a11c4a2e700be6ab7d1fd28bffc7b4bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dde6d7b24f3b1810804ba282d5eed4b784f0fe4ca1af16e6114a679441b1bee2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8adeb0bd1fe77cd351303c6620b49d8cd27713e03d3b4aba2f943b99fb8d78fb"
    sha256 cellar: :any,                 arm64_linux:       "a90d9b4c7ba9dc3f428bd044948c0c313290cd09085d71de09145d604610f3ea"
    sha256 cellar: :any,                 x86_64_linux:      "a1c0e8d3e7b9241000db40aff86dbe073fd7ec85f5e303794ff29bf62fe767d9"
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
