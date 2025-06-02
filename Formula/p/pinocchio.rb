class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v3.7.0/pinocchio-3.7.0.tar.gz"
  sha256 "c14c2ac9e5943af9acca9730c31d66c59b57a9407960d5b66d200f50b39a70a1"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "0914dbd5f4b010a3ad1b711a19fe907d1096acd72b8a21910d4bf4ece2fbf76c"
    sha256                               arm64_sonoma:  "cd8917e6e041b64acd4a9a29953114d607ca0eefda3091120d21342cb9e7c641"
    sha256                               arm64_ventura: "4e165c6d7d05547ad155bf2a9285279cb4ae2c9f4fe86337d5a8fbbdadbd2e71"
    sha256 cellar: :any,                 sonoma:        "b453324fac49dff80c51f9ce59e2d5ef9bc90c869f82da01289293cbe01ccf0f"
    sha256 cellar: :any,                 ventura:       "931210dd6e3b69895b955b19922904a8075054f4e4f7c9f490f890e407f41ee5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4a0a4a228135de418ed9bc60fb1cc2a4c0dc2299501b305fa15e1fd809c04c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92d2898ba583dd9e3501d50ebc808b793254dd3436f8177d6d1bb3bd083ecdf8"
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
