class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.3.4/hpp-fcl-2.3.4.tar.gz"
  sha256 "2b6f2911318627b368f6504e0df01aef2d2ab622e3f4f85ecba7f4bdca852296"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "896a31d6f1fb9a7bcc708aed0ab432c517087e2bea20cad1f27a0e9e7d400aa7"
    sha256 cellar: :any,                 arm64_monterey: "0c80b46964b6510a8032f8c8de79bab346d507598f029bc46e1b50b9a14e6d6f"
    sha256 cellar: :any,                 arm64_big_sur:  "ec5397a77ae847c8941ff746bef69f1d9dcfe575e1b904d26ed22843de74cf1c"
    sha256 cellar: :any,                 ventura:        "8fdd5346b7066cbed520ea472873383c93ba26a014971afaa08e1579ee8b710b"
    sha256 cellar: :any,                 monterey:       "1df8c01b96fcec299bcd7383c92d77128ed52b20fdf4b177036ea7c082d64485"
    sha256 cellar: :any,                 big_sur:        "632ee902587c81ce5519036311ab0a6bba5ba88b4201314abce5ad7f95501c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90938560fb8d280e8ab9b4d25599de34a5ae40c3d50710d16a54ca720eab9152"
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
