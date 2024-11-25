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
    sha256 cellar: :any,                 arm64_sequoia: "a78d5102e37727446e188ae3f2b885116c51e0dd54ca94709d16c43dd1e38684"
    sha256 cellar: :any,                 arm64_sonoma:  "c8edb4e650e857f57390308388eaedc2b1d17d58cb3dad208e8b30d3593b5f26"
    sha256 cellar: :any,                 arm64_ventura: "cbd7ce61c6721055bddd60f53b8932d3f0309614a1b6635a225fd409074ea0d4"
    sha256 cellar: :any,                 sonoma:        "ff5487b53675a5a88cdb0858b0c8df3a6baa17ccdb6ccdea4e3a5a947d6a08cc"
    sha256 cellar: :any,                 ventura:       "0e48086ae4525d6e3fd7745f704fe8514e0e72b05828e54f6ad71995d4c3cd8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c162710f44ea4bcdcfb735121c192337454a14a3e55e0a84a8f030a135b6ea34"
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
    system python3, "-c", <<~PYTHON
      import pinocchio
      model = pinocchio.Model()
      data = model.createData()
      assert model.nv == 0 and model.nq == 0
    PYTHON
  end
end
