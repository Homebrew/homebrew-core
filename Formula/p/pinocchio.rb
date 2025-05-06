class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v3.6.0/pinocchio-3.6.0.tar.gz"
  sha256 "3008e313e3d3321fa0a74d1c35a667c368953def040d74ca5a9b98f43ea50342"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "b9f39e535b830d12e624b2367e4b86c1fa76d61404c945963f92fb03e09b70d8"
    sha256                               arm64_sonoma:  "41cef46a824769a36b8e426d5e86b7cf03562085889f18daf08b5ac9b6c18e21"
    sha256                               arm64_ventura: "f5046d2daf9dabb289e350f8cdfbc639838563e7beb9b4cd48f5a8b7f9f2fec2"
    sha256 cellar: :any,                 sonoma:        "3c9a2bf916b020e7ffddb28b8028f4eb6db17ecce5edc8451e9f56ebe7cdbea7"
    sha256 cellar: :any,                 ventura:       "80c34d1477a6c1dd6de9f8d1255e6461ae07a0e3979fcd0b066358c8f2fe8c6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a155e68165ee3752bf7e35dc7da46a02be231aff06c190f41358a2cefbef987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2edcad83df0b003a0887f3ab833914e406913f031a073b3b5d79733f8edc7247"
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
