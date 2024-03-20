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
    sha256 cellar: :any,                 arm64_sonoma:   "781a3b121121e88517d0a6a6f413131ece78708216ec4d0c2f3cff62cbd7c590"
    sha256 cellar: :any,                 arm64_ventura:  "dd0e1dde8f163d57400e922d8ed5bd60aa74605a79278dab1c4b3cac9a873d9c"
    sha256 cellar: :any,                 arm64_monterey: "f63a49d966faa14097f9f4989ec36b986540f480d94b937b37191d97c92c859c"
    sha256 cellar: :any,                 sonoma:         "c9dfbb95fd4a4289424a26e1877eee71d067eb5ea9cb49e5aa2517b7cf053845"
    sha256 cellar: :any,                 ventura:        "463dd67f36178173769df0370bece739c552dd9cbe852d89d6745d4da4a4001a"
    sha256 cellar: :any,                 monterey:       "d90ba5eb31d2a99b37c75349ce45a72315adb27c29c05dbae258e1eef8ef1720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63a8f309e4549196bbf3cfd33b9f21c275ac74c5677b96ba36b775c0e5f8e3a8"
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
