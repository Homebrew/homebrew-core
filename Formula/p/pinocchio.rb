class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "devel"

  stable do
    url "https://github.com/stack-of-tasks/pinocchio/releases/download/v3.8.0/pinocchio-3.8.0.tar.gz"
    sha256 "aa4664d95a54af7197354a80f5ad324cb291b00593886b78dd868b1fd13636ca"

    # Backport support for Boost 1.89.0
    patch do
      url "https://github.com/stack-of-tasks/pinocchio/commit/fbc4ee6dcf3a082834472faef137aff680aed185.patch?full_index=1"
      sha256 "3e06a335e5722d8bce41825d2e4cc7c24ecb901c59bf5b4e1a41e7534508c35c"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "e19d2282d0794c232d922aa9e3a5af8f5ca23fbe4b25c28e9602450e6f39a61e"
    sha256                               arm64_sequoia: "beed70e9a4fcd296b71206024dedf8881ec0fcf0b6dbf58dc8c6b3f43b59ba99"
    sha256                               arm64_sonoma:  "44ad5aeba610332c165aec43354f5c93a44a46894626de76dc878c5bb3e4826f"
    sha256 cellar: :any,                 sonoma:        "477f4b339d7469f71458bff271d3195f0d91e33efab32d967bd30edd8546095b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fad8d887a620862757488344c7652a2ba75edbcd1aa67f0cf7bc346a5a38d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "442ad85615f7ef8f854c80ae37ac5607f50eeeca5d047092a763f832606ab4c3"
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
  depends_on "python@3.14"
  depends_on "urdfdom"

  on_macos do
    depends_on "octomap"
  end

  # Apply open PR to fix build with eigen 5.0.0
  # PR ref: https://github.com/stack-of-tasks/pinocchio/pull/2779
  patch do
    url "https://github.com/stack-of-tasks/pinocchio/commit/cd06f874671f44507777663fe36d643035d20300.patch?full_index=1"
    sha256 "f3bde3a9c1a094aff88ea11d767651f11a245d24857f375f4fed20f0abf58cbf"
  end
  patch do
    url "https://github.com/stack-of-tasks/pinocchio/commit/a25d222611a695a209375a27780cef5579c0e50a.patch?full_index=1"
    sha256 "1c54ce6f2b0ce1eb4f804794ac3ce812866cdfa784c521beb555d463a332dca2"
  end
  patch do
    url "https://github.com/stack-of-tasks/pinocchio/commit/2dd5857b4fb418de3b37c98d49b5f31fc59c5bb3.patch?full_index=1"
    sha256 "8a6b1f107af678de080b64f95e4525044e50f31c95a91cf0d892fdd09bdaa2c3"
  end

  def python3
    "python3.14"
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
