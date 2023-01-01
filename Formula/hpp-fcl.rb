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
    sha256 cellar: :any,                 arm64_ventura:  "f00073f61eb775e3d9e7f73cc6882173d473cce6211e435011fcb272753a6ec0"
    sha256 cellar: :any,                 arm64_monterey: "e36124ac134a54124fc034377c4aee3fa869138dac4a79e49e18134de7ea4bb6"
    sha256 cellar: :any,                 arm64_big_sur:  "df0644dfc03db2c90f3baaef21847cd9b94567065df56cd072659a3481cf9ccc"
    sha256 cellar: :any,                 ventura:        "53a8570f0096b6b415782d56a33422c2d7d4e54fef37c0601dc0796b2d898743"
    sha256 cellar: :any,                 monterey:       "bdcb1be8ef0dadbf79e14deaf89a73dbabce21ed1cc7aa26b5447fc018a7fdaa"
    sha256 cellar: :any,                 big_sur:        "bca186f60ce05e653f184a993432dc0df069aa4a070bbad8f20d9d4f2a1b830b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8751664a332c93ddbd58a57b82606aa2459c8b06c6fe33ca0827b16bc3182c53"
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
