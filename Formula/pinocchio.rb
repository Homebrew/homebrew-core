class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.6.17/pinocchio-2.6.17.tar.gz"
  sha256 "42ae1e89e69519aebd3eb391fbc6d24103fc5094ba03914a8f47cfcbed556975"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "297670791e2a7fa768a3600d9250a1677c6cc9b9c9f2bba8bfc28ed11bab89fa"
    sha256 cellar: :any,                 arm64_monterey: "56709f51bcb83bc48358a2fe6e66ae4ed5a38bcf5a4a9c5c6b78e8d8598943d5"
    sha256 cellar: :any,                 arm64_big_sur:  "05e7edc3f18717ec7d65212275c38a774795bfe3a9aa5b593f21a550a3063060"
    sha256 cellar: :any,                 ventura:        "03ac6df8f4adda498560576fac1b766d0e2f8bcd5b9ee6f9d2fae7ffe270a3d6"
    sha256 cellar: :any,                 monterey:       "08dacf4de54eaa26d1580f145994829edd7959397602632f8c78f608fc46631a"
    sha256 cellar: :any,                 big_sur:        "10d1ba94cf0074df7a532e488b2ee8230bea20d9049a9d49f9c9827c00715a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6edd0e8dae5881e8e402fb41ee6a021f923f4c6be3979bf94a42c5b7174b134e"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "hpp-fcl"
  depends_on "python@3.11"
  depends_on "urdfdom"

  def python3
    "python3.11"
  end

  def install
    if build.head?
      system "git", "submodule", "update", "--init"
      system "git", "pull", "--unshallow", "--tags"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_WITH_COLLISION_SUPPORT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~EOS
      import pinocchio
      model = pinocchio.Model()
      data = model.createData()
      assert model.nv == 0 and model.nq == 0
    EOS
  end
end
