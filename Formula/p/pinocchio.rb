class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v3.3.0/pinocchio-3.3.0.tar.gz"
  sha256 "a86ea06a7b4447d00cc46ed541a105f686957400eebb51b25aa41a93c08d855c"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3088be717f0b5ceb10f793515af84a55d1711b51cf7e73b5d7e6c3d95a30c9b1"
    sha256 cellar: :any,                 arm64_sonoma:  "1a14087e72c5ebe61e76027de8e4b13a839d08fc35e834f931290f4a07276423"
    sha256 cellar: :any,                 arm64_ventura: "a2fbd3bbebd1391a73f1d5e412d55e8fd8fb88c10ef601ed299d8da9a00d2e0b"
    sha256 cellar: :any,                 sonoma:        "9ce50ce56129f81cdf400a57e8bcb2ee4f47f2aca0fb1019b47f43793d0ca055"
    sha256 cellar: :any,                 ventura:       "f851f77332ec60ce5bba414612d13ef97ff4b2a22a92b356c2ed9c5c2d462a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "398598872be05caddc9bd4a74af3ad57c701d8cfe633db4f3a4e1679142fc1b6"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "boost-python3"
  depends_on "console_bridge"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "hpp-fcl"
  depends_on "python@3.12"
  depends_on "urdfdom"

  on_macos do
    depends_on "octomap"
  end

  def python3
    "python3.12"
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
