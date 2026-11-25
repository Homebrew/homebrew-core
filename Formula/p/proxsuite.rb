class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "54e1a9722786e7c064834677ba05d4708d523fbc8533adea9effa9c4451579a3"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "devel"

  bottle do
    manifest_sha256 "155b5aa0cf9962e26c5a0df00133a57d4e20631e379e5a0a861938cf7bbf866f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e8ddb605f47a24575a901c3c8a5f4013cb332b9fa4a1d941243482d916ff7956"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0d1e1392c544c2d48c43031e1ae22ef305037b6bf872aca784982088ea08916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b493370fe4b4b45f6cb2e862eef1771e678a48c501252b1ee2131e09597c9a42"
    sha256 cellar: :any,                 arm64_linux:       "7310dbd6bf2ae99edd0edf908931225398a62b4693003358afbe98db70b21185"
    sha256 cellar: :any,                 x86_64_linux:      "9e1173b88e6d589c4f0c364723185fdd63c7d2c258eb3d2e61c792b20764eb1c"
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
