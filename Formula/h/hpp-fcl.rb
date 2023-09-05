class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.3.5/hpp-fcl-2.3.5.tar.gz"
  sha256 "10bef1fc54d69372a3532f299460113b14f31bb2a569d4769b99b74aaddee92c"
  license "BSD-2-Clause"
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9ebcfbef4b88ca6240466450f6c320b86a14399e386f61aef6fb5404820cbb14"
    sha256 cellar: :any,                 arm64_monterey: "ca84a09ac744d26e75df095e0044d49c5146fb93aeefbfe9a0f4f6a73555c9a1"
    sha256 cellar: :any,                 arm64_big_sur:  "e72a1a61018e12ef4a55292e9cfe5f098e778afbc31b9eb1ee250f492e9f209f"
    sha256 cellar: :any,                 ventura:        "65792e840feaaf99144566c7ee8f5763f37e950071b220151813761f627beec5"
    sha256 cellar: :any,                 monterey:       "df3dadae4baaafd24cd7d79408ae68aaad150f08089a5e9b8891544d48b9b3e3"
    sha256 cellar: :any,                 big_sur:        "b8f43c30f2a3e500fa8a5e0a720b039c062d58c170f3ac880105f97aa753d93c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fe87ebf786bc7dcc3498803aebe35bc8fba37dfafea1b61a37c8661879b326f"
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
