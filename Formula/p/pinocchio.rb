class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.7.0/pinocchio-2.7.0.tar.gz"
  sha256 "fbc8de46b3296c8bf7d4d9b03392c04809a1bca52930fab243749eeef39db406"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f0caddbf672e03a214f78b589f594c6317346a4c2790a7f28ffdee41a8e8fd4f"
    sha256 cellar: :any,                 arm64_ventura:  "b2b94efe37e792c6272da3737ceac82afd0ef5165428f0d0a8913b261c8f0da6"
    sha256 cellar: :any,                 arm64_monterey: "44e70fa73cc27aa4780bc4806eebcc75e86880d7a3ca9459fddc8601f92fb9ce"
    sha256 cellar: :any,                 sonoma:         "3ec5c92d6b38d40b46f34c768ae4cba54f4b8e4b386c329c8a772559f2e6b096"
    sha256 cellar: :any,                 ventura:        "4ac82f5ce34dabaf690a273c9a2a47d74861eea3ce19b5e2cc1e077486d55236"
    sha256 cellar: :any,                 monterey:       "1e005fd1bc55829b15e0774d6b53d890742c92bd77bb9ba1884c492242cae77d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8410153b365807d6dd9157d52372afe849ed8abbda6c5b9f12e9ac720f137904"
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
