class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v3.4.0/pinocchio-3.4.0.tar.gz"
  sha256 "bf899d59b69b7da4ae56ab038aaf46b11561b0ed94a460b31fc04168a4a847c4"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c7d19706c5b74c7b05c625cc429f8c86884f233d9c1e80b86047dc751a9c750f"
    sha256 cellar: :any,                 arm64_sonoma:  "cd42e50a81e150033160382496dd7b88f39a4e8efd4d23da9484aa04f0aa0ead"
    sha256 cellar: :any,                 arm64_ventura: "b7b2370a6e7fafaa81d887e4ef4300b35b1f044ae17c1170b3d1f9b0f00f8d9d"
    sha256 cellar: :any,                 sonoma:        "87b0fcec3cc269e7d7de6be1927593f2b82cd559242a82be83cb4336d4cf0f95"
    sha256 cellar: :any,                 ventura:       "40f2a92331596bba6a5856d82a4f56bbd55129c154c2bd0274011a33b23e6a9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d81a4ca36a512f577a685220936f204f82e2751313af4acec13a688e32966bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22267efc9615184c65071a9d21c51c47639a6ba2d3640aa0b091cead00cad65e"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "boost-python3"
  depends_on "coal"
  depends_on "console_bridge"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "python@3.13"
  depends_on "urdfdom"

  on_macos do
    depends_on "octomap"
  end

  def python3
    "python3.13"
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
    system python3, "-c", <<~PYTHON
      import pinocchio
      model = pinocchio.Model()
      data = model.createData()
      assert model.nv == 0 and model.nq == 0
    PYTHON
  end
end
