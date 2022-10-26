class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.6.11/pinocchio-2.6.11.tar.gz"
  sha256 "e91d0ef957c8a0e9b1552f171b4c0e8a5052f0d071d86d461e36503d775552b8"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "98bf766f77d368bb184e39c9c33281f00abd7c69c5cd5d6f17ac8843b6cd43ac"
    sha256 cellar: :any,                 arm64_big_sur:  "58bdd9a4ddea7e81086889d6cbe079f0d4eef3e5a0c254d8a64921e31bc07229"
    sha256 cellar: :any,                 monterey:       "8d68c4d2056e66623b40aa52c8bf901dcd9d0443f638252580af2f7c0acc7e8c"
    sha256 cellar: :any,                 big_sur:        "42cbac5983a70777ffd7c3633e1224758bace5bf4159bf879edfbdeebfc59ad0"
    sha256 cellar: :any,                 catalina:       "00a3b64dd1034bb130090c25ee0a4fe926f6defe7bee9a0ef844e0616edba48d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "800f485575744a2500673df753ae8a1cde33fb900bc19190dfad990d28c99c1a"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "hpp-fcl"
  depends_on "python@3.10"
  depends_on "urdfdom"

  def install
    if build.head?
      system "git", "submodule", "update", "--init"
      system "git", "pull", "--unshallow", "--tags"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{Formula["python@3.10"].opt_libexec/"bin/python"}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_WITH_COLLISION_SUPPORT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    python_exe = Formula["python@3.10"].opt_libexec/"bin/python"
    system python_exe, "-c", <<~EOS
      import pinocchio
      model = pinocchio.Model()
      data = model.createData()
      assert model.nv == 0 and model.nq == 0
    EOS
  end
end
