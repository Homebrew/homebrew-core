class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v3.5.0/pinocchio-3.5.0.tar.gz"
  sha256 "5a1d521c5f885768075016455d3f9eb50bfb258db540c2f2c681ad251e25736c"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "c901b546f36d193bb1e73057932119dc8d7663409b4108049fd32abecaf70226"
    sha256                               arm64_sonoma:  "d6f5861487a00dc43d94dcd5cb1504625d5025ee2141076e43f9f6f1dca9c3b9"
    sha256                               arm64_ventura: "8a5bae63994e6303ecdf7b75e16663c3e1d2b035866c73b467f3bb9fdf66f036"
    sha256 cellar: :any,                 sonoma:        "e9b6a72236cad1c56d0d7c9b78ee08c788e776e8f2cf4786f62596fd472541b1"
    sha256 cellar: :any,                 ventura:       "dba1d77a5e030d3cf60a0fce8f709ebade8dc2ea8b9e04d5d2f49842883408f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb619d9f383062fd47f4e8ea0f4306eadad51d997d11e8786e02f143d7aa7669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a586035d5eb4bd44e4016fa1fe07cf66055a224e09335b0ac1d2262db7fa6f1"
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
