class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v3.7.0/pinocchio-3.7.0.tar.gz"
  sha256 "c14c2ac9e5943af9acca9730c31d66c59b57a9407960d5b66d200f50b39a70a1"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "a7e991ba1cefe495662548cab079b970ad2f4f268f5376919db2351c723ffeff"
    sha256                               arm64_sonoma:  "6d605216264a3f81df44b27b4e71ecf7ca4587dbaf824ed2842ddd9574636d9f"
    sha256                               arm64_ventura: "67683a60f0592dba71505ec5697a0631342f0ed04b128813b0b5603de9bafb94"
    sha256 cellar: :any,                 sonoma:        "716ab2d6b64fd7d90f919affcfa281aaad4b4f983ed8e1a9867c1d3a36cdd1c9"
    sha256 cellar: :any,                 ventura:       "7b44a435d4aba4044b3af9d8c422aad6c166398077b45109929c383319749170"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24d9ae2da4fba1785e266a7b2c0805dbfbcb97e053ab97320bccd2a4cfb54417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49812f367b27ea61b1e847a7f844a8b4560a10fc3763619524a06f88fc1489fe"
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
