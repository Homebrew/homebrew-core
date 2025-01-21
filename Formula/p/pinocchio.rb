class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v3.3.1/pinocchio-3.3.1.tar.gz"
  sha256 "83f7af674d65ec1a03bf46f0230a227ba0cd696d46047a82fe87a93e710837e8"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7f247a3e2e2be1c17bebb01a2d647d11576edeeb19e3645fd69f0ec21ba56d04"
    sha256 cellar: :any,                 arm64_sonoma:  "fc8febc3365404e946d4262cf2728bd0715b6ecfca875aaa4aed7f4c98bbce18"
    sha256 cellar: :any,                 arm64_ventura: "108d3367f92fa4f8d3b298206a16cb57b0c5fe18105c8b3c6505a7490fb30e5f"
    sha256 cellar: :any,                 sonoma:        "ef380007857cef57ec5701c8469bc62814f4066eda07fabc8211464a31f9461a"
    sha256 cellar: :any,                 ventura:       "84159d06a16cd972cbbc4859f32c048e3cc0d1cd10629b1365107b0c05da240e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45bd97ad141cd6648fd498e6a04a07e2a3c0a4ab6b0b62338012c8a0063ea54e"
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
