class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.3.6/hpp-fcl-2.3.6.tar.gz"
  sha256 "17b7aa65d942168b44ca4ad17be28454aef50729867034021d7789a122dce6a7"
  license "BSD-2-Clause"
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "feef6968977b06720c55d0533ec7bf1ca70f7aa0a8b51676424a969b938311cc"
    sha256 cellar: :any,                 arm64_ventura:  "f4ab492b7f4827669355078e6aeb2265498c77e9c54a13f506f03a753c37ecd4"
    sha256 cellar: :any,                 arm64_monterey: "43bab3395409fc372fb25d4de2e410ee93424b66b89e3ad17f142419d44de996"
    sha256 cellar: :any,                 sonoma:         "251c14b38f5170ba770d0df667593a8c3c16f7af7a089e6881a9516933e296d8"
    sha256 cellar: :any,                 ventura:        "1a2f61c00c5ffab58b80483db6b0f7517e273ec40285b9e574a651647adf5677"
    sha256 cellar: :any,                 monterey:       "d01612c9e3977ed2b6889bd74a0aefcfba2e83a3b65474dc1ff6b2c8f2593bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19299ba8ac8ce7818337cbed5f502c8818c0016d409b485713c66894f0d415d2"
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
