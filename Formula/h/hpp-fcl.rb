class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.4.5/hpp-fcl-2.4.5.tar.gz"
  sha256 "14ddfdecdbde323dedf988083e4929d05b5b125ec04effac3c2eec4daa099b43"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b7ea572e39be59683ab038005869064d277935d8e7b73fd6949cbea804807d94"
    sha256 cellar: :any,                 arm64_sonoma:   "c5b76ec9d73c6c3d1a21fc5c53df326193b111976d39811f653658033fba4f0a"
    sha256 cellar: :any,                 arm64_ventura:  "7fa6af2c6a84af609f2d24d3695fb26e912ef8a8f04ae79ab0ab06f611a65651"
    sha256 cellar: :any,                 arm64_monterey: "671f42a80d772939c4abd1b7a5173556ce7a64a30d99e58e71ec42cc1e980e8b"
    sha256 cellar: :any,                 sonoma:         "b5882428aafc54764fbb6c958602354b0df13e27f1a459b03ae37372524aec08"
    sha256 cellar: :any,                 ventura:        "22103d837c91566948f2afc780a6751213da579111d3442fb21afaac6c0ec2f2"
    sha256 cellar: :any,                 monterey:       "c794634a655bf8924f2ffbf60044ed8a7836af3f6d3ad1e5ff9d8034212562e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f34dd3b05301b1ddc6465f73c63d8b3b8a23d0170e1856ee37439f102bbc8e8"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "octomap"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~EOS
      import hppfcl
      radius = 0.5
      sphere = hppfcl.Sphere(0.5)
      assert sphere.radius == radius
    EOS
  end
end
