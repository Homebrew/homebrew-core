class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.6.17/pinocchio-2.6.17.tar.gz"
  sha256 "42ae1e89e69519aebd3eb391fbc6d24103fc5094ba03914a8f47cfcbed556975"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1115b38e228404f4f26bf3e5f73d32f683228b99abc9a9c6ac1263cbcc1d1da9"
    sha256 cellar: :any,                 arm64_monterey: "849a51002a17484d3c202382b5f6ea01c94cc2772dbd8c0ad6fdf348f9a771af"
    sha256 cellar: :any,                 arm64_big_sur:  "5cf11e71afab073ffd5aba5cc582565059e609eecabacdd0d296e7c7eacb3933"
    sha256 cellar: :any,                 ventura:        "7ffce5f7c16914bdead331b6193e53ba8f3bfc829e981814dfdca16b493b0fe9"
    sha256 cellar: :any,                 monterey:       "dc95cc2081e8226d5067cac80ef9cbef8461f8da9c46551dab0ff7acf627c9a6"
    sha256 cellar: :any,                 big_sur:        "db8355c31e6c33c56cd2be4067e973f0f589a6b6e618bbf9f7824a313a29b920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba12a7aac1e5f3b6c8563a13e6c7549213095586845ac4d9f2c186f31dcfefff"
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
