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
    sha256 cellar: :any,                 arm64_ventura:  "a66c506b2b70c8df039951560c4f946ca9121928a04f6c55afb05266ebb04fd6"
    sha256 cellar: :any,                 arm64_monterey: "8718c94f42d371fa5c29ca5c19a1b230f3f4cfb67e301032149d64f1fef28d04"
    sha256 cellar: :any,                 arm64_big_sur:  "440d3bfbc7b57307a3c8678c1d5afbf4a5e668076f4539abd8649357883bba3b"
    sha256 cellar: :any,                 ventura:        "7abeb59b34b6b2e5419b020030ac97e6e55a31b07585be54b2226e2288c963f8"
    sha256 cellar: :any,                 monterey:       "703929ee56eea22372d041bc2e36016723e35d389ce8be017139179b809c9859"
    sha256 cellar: :any,                 big_sur:        "fe2e96ff9333cb515afcf5a87e23beefb5e99ba673b49e7e3037f5ec0360ebab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4787b6d6fb529a0f30dadd84d9e5218287e0bcbad3acbd7225ae9097f47bd009"
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
