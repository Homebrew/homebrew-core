class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v3.1.0/pinocchio-3.1.0.tar.gz"
  sha256 "e624484077eee3183e20443ab0373205bb832a2597241531705116fa9f07016a"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "706ba41a2680dedbad4156614f5f748eb193f0260580e29eb0517b16033a72c4"
    sha256 cellar: :any,                 arm64_ventura:  "d8dfa7d2c8be6b5638ff60b8646137ec49c80c5f9c12be2ae14111a7e14dc480"
    sha256 cellar: :any,                 arm64_monterey: "d0a1b9567dae9b921c0ae5c89289e1b2570890716efae388b4a1fe4babbbc441"
    sha256 cellar: :any,                 sonoma:         "859f049fc95dd24dd710a852a2ccecde2b815c25ef1da55e5933ab171c55e077"
    sha256 cellar: :any,                 ventura:        "2104afb06d3b5b0f9ffff92c42245058b05465a13f27c9eacc1624b3021065bf"
    sha256 cellar: :any,                 monterey:       "18d7c261d9265f3bd75da0b984033aba68b93edb7ee4eb540fa4adce0de66520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "039a36215390c366507653cf8139d55e0b2dd803ac5f68b630d81c715e6c4f01"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "boost-python3"
  depends_on "console_bridge"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "hpp-fcl"
  depends_on "python@3.12"
  depends_on "urdfdom"

  on_macos do
    depends_on "octomap"
  end

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
