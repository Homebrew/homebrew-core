class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.6.11/pinocchio-2.6.11.tar.gz"
  sha256 "e91d0ef957c8a0e9b1552f171b4c0e8a5052f0d071d86d461e36503d775552b8"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "684c665088398c58794c6309f2534abf3f45570c0a153e6047f25e1961a886e4"
    sha256 cellar: :any,                 arm64_big_sur:  "e4e16ae25c36ac1272b84ea58d12a3c09dbca9dfea608f81949d4461a682e827"
    sha256 cellar: :any,                 monterey:       "7a5af44fa38e5380c886998160cfb8e127ce2c53ea10e298566d6a8a44701538"
    sha256 cellar: :any,                 big_sur:        "24d188ee1318627cbf283cd475cb956c8c5d1a6f3f3244dfea48ef9619abc141"
    sha256 cellar: :any,                 catalina:       "123ee38e0e3757fab4f2eccdb7b3be072682479ee8b9a9b8c923f8b5c2113054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b64cd33273794837ec439d1c82cb10eed83ceb8a3d27b515ed68d72f788e787a"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "hpp-fcl"
  depends_on "python@3.10"
  depends_on "urdfdom"

  def install
    if build.head?
      system "git", "submodule", "update", "--init"
      system "git", "pull", "--unshallow", "--tags"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{Formula["python@3.10"].opt_libexec/"bin/python"}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_WITH_COLLISION_SUPPORT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    python_exe = Formula["python@3.10"].opt_libexec/"bin/python"
    system python_exe, "-c", <<~EOS
      import pinocchio
      model = pinocchio.Model()
      data = model.createData()
      assert model.nv == 0 and model.nq == 0
    EOS
  end
end
