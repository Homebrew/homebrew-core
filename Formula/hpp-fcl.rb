class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.3.3/hpp-fcl-2.3.3.tar.gz"
  sha256 "404f0a55322b6192fda62e65e6963db0abf77da9336482d1dec4d77a460a84ae"
  license "BSD-2-Clause"
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7e83043decfca3915edda85db23e4c901c56d7df1efa612e70782b881360852f"
    sha256 cellar: :any,                 arm64_monterey: "320ba84b57eb94577860b738f45ab427b7874761ee276cf305dcedd7c300a4f2"
    sha256 cellar: :any,                 arm64_big_sur:  "bfc33c2291dc5ca91ffdd2ce9e233476992924b18edc8747d6f821665bcbc8f8"
    sha256 cellar: :any,                 ventura:        "72a07a5f6174d0ffea3a029a5c1f8f05fad03fba957849f93a2b451004f78594"
    sha256 cellar: :any,                 monterey:       "acc7390bbe9f44bc678e08e7d1bd91435d88f0886f47f75068438b0ce2ce71d6"
    sha256 cellar: :any,                 big_sur:        "d42d8d091d90f557ad90a3462415531dc8bf92388792f2c5d5b340d517318e03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "912f2c547981da72e09dc3c6f49236af1159ec8cd94a551e8781f2e879f9f0a3"
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
