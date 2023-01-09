class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.6.11/pinocchio-2.6.11.tar.gz"
  sha256 "e91d0ef957c8a0e9b1552f171b4c0e8a5052f0d071d86d461e36503d775552b8"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d55d40b6ad76a64c3cd885fbd2e9ef167f710c24e1faf0ebef1e22b163ddd540"
    sha256 cellar: :any,                 arm64_monterey: "ff735a05ef378ad374a036df367b32221579f84cebc2e86a420541bf2e2e8b69"
    sha256 cellar: :any,                 arm64_big_sur:  "b682b22a58f09428698666379b0aa1625cc000066d37b2b0dc8cf84083e70614"
    sha256 cellar: :any,                 ventura:        "e483849f599872f580b7e4edede1dc01a5b6a126c65cc309f7c53acbebac53a3"
    sha256 cellar: :any,                 monterey:       "532130106302f6db57e2a428c778157dd416e13094881281b5edc81fe09e7aea"
    sha256 cellar: :any,                 big_sur:        "6aa6e27a18117e9ab7909b0cebb096b313703f35b8e79d598e92babb946cf8f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad0d69fe945fc706e2c2d99191df3a4e7049880b608f895b6cf7da03732659c6"
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
