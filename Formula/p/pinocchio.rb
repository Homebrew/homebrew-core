class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.6.20/pinocchio-2.6.20.tar.gz"
  sha256 "2fcead7b1b2f08aa47acd28891e4b204f2e9cc14a4e4c9027168b8c58f9aedd2"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "17438d1a1a62a985b37da67a5b239dd9fd36e5d784d4dcb05df07ed4dd0636fa"
    sha256 cellar: :any,                 arm64_monterey: "bb765bc71e766c50bfd8a8fd3f1ed7c4f85a63f34c2fe2d145b06e9c36547295"
    sha256 cellar: :any,                 arm64_big_sur:  "4e30be51dada386ba8d3beeed1e7e3e52fbc480e23346a6c6667964ac5af9643"
    sha256 cellar: :any,                 ventura:        "2db0a491c86c36fb7b76785bad436cd9dc0d8b2259b4b97bd181ab8bcc1e368d"
    sha256 cellar: :any,                 monterey:       "bb4040ee5e150f47477e83b50c04560ae25261a6824489064653d160e874c82e"
    sha256 cellar: :any,                 big_sur:        "54988b7d293941778115dfd93d579c8a7a86f9adf38bb4267a9a10130773f287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6da1057fe635648830480ba4c6189818e3f818fc6a728ac2977472b575d23b07"
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
