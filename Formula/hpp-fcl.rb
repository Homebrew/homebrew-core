class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.2.0/hpp-fcl-2.2.0.tar.gz"
  sha256 "deb3d8becbd47258e3b327f6025f581007b4ae7047a38e0a32f524bbdb74d489"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "61eb2e98ad5830656929a50115f45de0a2e99722ce5b5cac41607ec9d6666542"
    sha256 cellar: :any,                 arm64_monterey: "0fe63d78bc301f027084ada4815fb47ed21b02db7a67b4aae362677e41b497cd"
    sha256 cellar: :any,                 arm64_big_sur:  "ff0cdec28c3c4ef56527459085e37fcfbb4938fb549c817618f42d730365ff0d"
    sha256 cellar: :any,                 ventura:        "24fafd183bcc92e56034985fb13add1545e8844af3a8cafe32ad3fc6dcbd3127"
    sha256 cellar: :any,                 monterey:       "1d278c900225bc6f728249b85b73f1a8b39ef8d4c9c6bab1162b928f8c1ec480"
    sha256 cellar: :any,                 big_sur:        "c20fb07ffe129e735906d85f16a03c198724e5ca77ab8fd9646f205d0d2a4749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38664f1f546d5e239b07379c476a34f379644a1bde35ec57989d7bdba0ea9ae8"
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
