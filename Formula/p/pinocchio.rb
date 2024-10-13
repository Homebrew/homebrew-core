class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v3.2.0/pinocchio-3.2.0.tar.gz"
  sha256 "b6a7e6f6f6e3f175dd7010aa998a018f88d712477caa6c41f6ae038310c2fd7d"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "287fc7e57114de6aab36ba53ce86b4cff23ad61c446e0af0ddc54d99d2c28319"
    sha256 cellar: :any,                 arm64_sonoma:   "e5aecd8d45644b8e8816b8976380b0d56a90d3c58fbaacffc25d38c313d2703e"
    sha256 cellar: :any,                 arm64_ventura:  "98d4385db1a890c8efab927d13cfa7d43825a01f747a35f232867864be056dbd"
    sha256 cellar: :any,                 arm64_monterey: "1521650db4d1d0b81fd049a48df5c6166c000229f6a399f1f3605d6c37a3310d"
    sha256 cellar: :any,                 sonoma:         "3c6530280e7008d33b3077669d7e718a19463da9e1e48b2fc70cbaa277909261"
    sha256 cellar: :any,                 ventura:        "458b37e151cc241998b1094a6c7416a041aa9a6160de8c7fa42ab142190cd0ea"
    sha256 cellar: :any,                 monterey:       "da6b92220a00a51ba948bcb9d9e3848fc951910eb7eaa9a1527895beb29580a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a09640f68ac89dba6af85f0a056058747643772a95388ab7cde28d9097db5332"
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
