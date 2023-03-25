class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.3.1/hpp-fcl-2.3.1.tar.gz"
  sha256 "54d272bc656f2ded95d181f1723a5cc0ef55489ada9199ff7d669a7cd2d00521"
  license "BSD-2-Clause"
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aac1d47601c6866bc285196d8c0b134c377a13e806d83a2a27a7dadfa2a7c580"
    sha256 cellar: :any,                 arm64_monterey: "8c403631beec96e4faf6e2bfb82175ce6f628d7b1bf8b63f5732313a27734369"
    sha256 cellar: :any,                 arm64_big_sur:  "4d7061bba2005668588e6d908e07facbd70845d4efa0dcc8c953d2c195f59053"
    sha256 cellar: :any,                 ventura:        "8082850d54be32133408c15fd0b05c1e19dd9733578b14bf3760bbcf2e65b69f"
    sha256 cellar: :any,                 monterey:       "420afd01ec63e435d1bfa083208251f497b939ef5b7191231a794b5ef81bddd4"
    sha256 cellar: :any,                 big_sur:        "7f4c8198bbf410655b61626f04393e4d74e430f8ec39199cd8e89ff93fb92132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21199f3e3cfb3d018af6eb5854339b134755d49f9580440b5aa82922d8e379ca"
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
