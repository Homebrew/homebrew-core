class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.3.4/hpp-fcl-2.3.4.tar.gz"
  sha256 "2b6f2911318627b368f6504e0df01aef2d2ab622e3f4f85ecba7f4bdca852296"
  license "BSD-2-Clause"
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "122d58d711ce16c3fbe7a92fe96fa3df0e0589b85adc4a231057a00fca102a15"
    sha256 cellar: :any,                 arm64_monterey: "cc8603bb99f14956ef22c94120fc1781f6cc6261fc979b44bde767be32f1ae94"
    sha256 cellar: :any,                 arm64_big_sur:  "8d0bcbaf9dafab53db735dbed3f472bdf5e29e8b8c7b2b3fe2cfee70ed9c728d"
    sha256 cellar: :any,                 ventura:        "f35dd8709b443605d660153deebdaa885e2f506aa715fefbb1da00904295b22e"
    sha256 cellar: :any,                 monterey:       "a8ce2725b32095a2522561f367753112ab16998061885908b0d52c381b47a318"
    sha256 cellar: :any,                 big_sur:        "729d5c1f9283fd8d830ffc51cb4e80430aca6e6b8c64865b73676c24ab6f5e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "277f358275e171bf4c924ed81d8b3e05ebb30933c4b5381570fec0b7f4a691c9"
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
