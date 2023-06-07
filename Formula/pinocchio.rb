class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.6.18/pinocchio-2.6.18.tar.gz"
  sha256 "c497db0c7f31e7302d73efdcdc5f2834c76d25944b53d70a909991f4a2052c08"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e68b05fc300391dca49266ac219939a286e6682d2e7b277a4e6537698100fd65"
    sha256 cellar: :any,                 arm64_monterey: "62ce838f3f1ec87016ca950e5fd2a06fb3573dfbc7a2096777a1ffb385c17642"
    sha256 cellar: :any,                 arm64_big_sur:  "dd9861c3505ce15724ad1db48d32de9b588e8bf6daa67c1685988327120da2ef"
    sha256 cellar: :any,                 ventura:        "6a00393e97ae207f33cbdc72263eafa35b2fae44a6e93bc4f5da3269082857a4"
    sha256 cellar: :any,                 monterey:       "03dc31a1ac5fc2e50e787a397b118a3e27eb9edb5a907153e39bfc3066198cee"
    sha256 cellar: :any,                 big_sur:        "b617f51c03b9a512bb826569c0728b3684fd509bdcc4925eaaddfc37113abd60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28207d34507db0105ac311c8bec8a2daf223490d2f075458c58df6fa59fa65e5"
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
