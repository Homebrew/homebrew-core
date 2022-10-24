class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.1.4/hpp-fcl-2.1.4.tar.gz"
  sha256 "ab6ecf1abecb0f85456ce7d648b81aa47d49c9dac07d9824841505769ff45c9f"
  license "BSD-2-Clause"
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "198681d6645fad56df512b3b8d211a83f4bce40c56eef11cbcee68a49e1cfa62"
    sha256 cellar: :any,                 arm64_big_sur:  "f2ab0090a0e06743cc36d0f54e8c07016f19ab46e7b27b4d96e08ad3d05ba9ab"
    sha256 cellar: :any,                 monterey:       "501cbc7712d15df6fff6d56d25e9c46316463b6d3260a473f1b7ebffddcf0d01"
    sha256 cellar: :any,                 big_sur:        "b204828588094f682ea08673d32dcbd5bf0a3d4e2ad2f5f9f38022b54595cf76"
    sha256 cellar: :any,                 catalina:       "7bb0dede67f3051b7ca8d5012e8996f29a3affd02225a07f1e4696b0e285c965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17a82a1fc0977a5a96aa4e1a4639bc7023a3ebf946c96542aa230d65af22b2fe"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "octomap"
  depends_on "python@3.10"

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.match?(/^python@\d\.\d+$/) }
        .opt_libexec/"bin/python"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{python3}",
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
