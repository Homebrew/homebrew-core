class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v3.5.0/pinocchio-3.5.0.tar.gz"
  sha256 "5a1d521c5f885768075016455d3f9eb50bfb258db540c2f2c681ad251e25736c"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "74dbefe8d3aa7ee07a6ffb1cd106ce95dce1cdf78af6ce8405d61c62a48fca82"
    sha256                               arm64_sonoma:  "91a2fef43b6a388e42cc65d90c6b2657fcef2546888f43e306e2bcdd6ed50b5e"
    sha256                               arm64_ventura: "e896e19422db890ed0389bfb6b74e51ebf5b1d03d8d550c0952389e431a148f1"
    sha256 cellar: :any,                 sonoma:        "ab268f575aed90b0141412f7644e9812509c52ef8b049865fdf8c479eccd1366"
    sha256 cellar: :any,                 ventura:       "78cdc403599fca47cab098e77e04f5aca3c9d70ee32e91f453e622ac8468a838"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b699c1f0963eadc215e56cfd60653bc49d822ca616bcab7ae0fb664e198b152d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5df171d9789d3ad7f30ee65f47ae784953102436bde6ee899c9df751c7ad6aed"
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
