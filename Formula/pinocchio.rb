class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.6.17/pinocchio-2.6.17.tar.gz"
  sha256 "42ae1e89e69519aebd3eb391fbc6d24103fc5094ba03914a8f47cfcbed556975"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3d7812a9ec476c35ac259f322250520a54584868568aa4cb314f27405bbc52ba"
    sha256 cellar: :any,                 arm64_monterey: "6a145f843355437817287be7dd0c28f94d8f0ebd032daca2d7ed4b31081d838a"
    sha256 cellar: :any,                 arm64_big_sur:  "1dd1048792d08e340d906629a075a2b51a210f9e223d2c717fb85d3c225e3a42"
    sha256 cellar: :any,                 ventura:        "9be178353c852b20d8a6500186a859ce7a8f2c6aceac044d4a3fae820b464766"
    sha256 cellar: :any,                 monterey:       "13975f126c22dd9af2859812e1f4df42065ce057111bf93aa1dcc406b7362720"
    sha256 cellar: :any,                 big_sur:        "99e118ce4f50b1627435faddf50db7ef2a361ab1f4394c6157db7d303fa707f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea1412306fd8e21a221e78b8aea37e742071191a3a7f42042da01114c2f542fb"
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
