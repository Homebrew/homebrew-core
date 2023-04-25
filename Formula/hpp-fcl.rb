class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.3.1/hpp-fcl-2.3.1.tar.gz"
  sha256 "54d272bc656f2ded95d181f1723a5cc0ef55489ada9199ff7d669a7cd2d00521"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c5e9461f044eec828e8def663376d6b30ed084e574fcbcabf7c96a0cddf3c7ac"
    sha256 cellar: :any,                 arm64_monterey: "a47365212c7dbd5ed2e5a85a191840cdaae25fe947405b45262590c81f8025e6"
    sha256 cellar: :any,                 arm64_big_sur:  "f0242e4aa07d44861a406103aa2bde445f1fe4be0a3f3d8ce157b8354bda00f6"
    sha256 cellar: :any,                 ventura:        "b2f8feca9284808cbd2c1c351119e63e82fc2017d6f3824c9276eb9fa4775d2b"
    sha256 cellar: :any,                 monterey:       "dbe32ca4d973249c646a3ec214070f08deb61bf464142ff151bc9f4f6ab9c098"
    sha256 cellar: :any,                 big_sur:        "c0a9b9f73cf9267034fce39d2aff89c858dec8de6a52b5783be68848d56b89bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d5763ffd9bf12bfa6ae64c18d431ed002e675a50fd43e47945bf89b848d3321"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "octomap"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DBUILD_UNIT_TESTS=OFF",
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
