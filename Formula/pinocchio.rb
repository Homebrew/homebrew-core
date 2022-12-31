class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.6.11/pinocchio-2.6.11.tar.gz"
  sha256 "e91d0ef957c8a0e9b1552f171b4c0e8a5052f0d071d86d461e36503d775552b8"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8db5fb9ad64c7c9f52b6d58a92c873c7f3a73803696858a4c38628f21ffb6f4a"
    sha256 cellar: :any,                 arm64_monterey: "13c90fddb707a9b0ac1dfc3e61fffc9bcb19cac60d2cb48daa0acab63ca7c61c"
    sha256 cellar: :any,                 arm64_big_sur:  "7a406174b3b93bdebf9d73ec89deaabb73fa744d8f23e4feeed9b1f27f82e86c"
    sha256 cellar: :any,                 ventura:        "65389451277e7418b672a422dc22c59c7a899c352275786a2ec38fff48890d36"
    sha256 cellar: :any,                 monterey:       "ded3e15c0928e4ccdcf8e2544b6f5c2bfefe258a43668964b0518ca67bcf324c"
    sha256 cellar: :any,                 big_sur:        "8ec4cebae4c9884ca03494090e2e0ce4ce65b1dbb381858e4c8bae7da81e337c"
    sha256 cellar: :any,                 catalina:       "179af5d6985f8d5c1ec88c7ffb5a2d987f358fcc63a28f71d2fda89cbb40f06e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dce7fe7e3be0987cbadf5713c9ba2a17623310c50197db10693fc5e279b7a1f"
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
