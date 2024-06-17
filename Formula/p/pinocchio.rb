class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.7.1/pinocchio-2.7.1.tar.gz"
  sha256 "fd50b72f9f32c14c8f9e7712d9abe077c154d2072e780faf12cc132cc198815f"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0e2575f8d573f3760be3ad8de68785c552935d4479196ad53bb2fcc4ead3dbcc"
    sha256 cellar: :any,                 arm64_ventura:  "ba757831239ab83459de79d8411861c5950e6007394721bd9369073da00b9a2b"
    sha256 cellar: :any,                 arm64_monterey: "7103ae81cdb44f41458d8dee0e9c91f946ec11b7920f7815dceed29d630ba023"
    sha256 cellar: :any,                 sonoma:         "2d0a09efb7e362932f1758caf129203aed2b5b10295a4cc512979d332bd01bcd"
    sha256 cellar: :any,                 ventura:        "d31f608a766fd378b309755067f707dffad0b099ef7c6a2b452a8520724be2d3"
    sha256 cellar: :any,                 monterey:       "e71c53c9c664f6e9b666d85678a2e8a32c9148b0500201b1d096dc007f08fcd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8051834fa5c74a06105dcf814f538c5234e38ec84de4075f41d60c8c56bf4b9"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "hpp-fcl"
  depends_on "python@3.12"
  depends_on "urdfdom"

  def python3
    "python3.12"
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
