class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v3.9.0/pinocchio-3.9.0.tar.gz"
  sha256 "60553630d83de492bc0cf1126add2acc591c87f1bc8ea7f70693e7563fc103a3"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "86760207b0a7782de6ca11d04726d572890eb3cba376d18bdd5d7c443daf3556"
    sha256                               arm64_sequoia: "678658704bb233f5551f42558bcc2fe6059393b40778fe82a835ce22f0e552de"
    sha256                               arm64_sonoma:  "5b909398a93744936f8eb31da544d85956036ef736d167d751fed2fbe3eb28dc"
    sha256 cellar: :any,                 sonoma:        "88cccbcb3217a83fb2460ae41b38afd9d99edef7e3e311e25d84bfc56d48b765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63d9387d9e37e929257b1e50f02ae50607d4ffa600082a6783fc1cdec975dc11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b2477eb36d42baeef8bfcd2456bfc1b02ac161297a880ad5a301785e2993732"
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

    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DBUILD_UNIT_TESTS=OFF
      -DBUILD_WITH_COLLISION_SUPPORT=ON
    ]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-rpath,#{rpath}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
