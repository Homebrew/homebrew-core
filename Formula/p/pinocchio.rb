class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v3.9.0/pinocchio-3.9.0.tar.gz"
  sha256 "60553630d83de492bc0cf1126add2acc591c87f1bc8ea7f70693e7563fc103a3"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "76519ae746289a93cec4f920ec69008b4cfb5009128b49f8b93ca3da3186088c"
    sha256                               arm64_sequoia: "8e81f8df06f2b904969ccc8bd63e34a47f230f83a3bcadde5263f931c99a9d9e"
    sha256                               arm64_sonoma:  "48b114b546dcee6ec4904676afe63969da9d46535dce19a7a87ed83ac0ef3044"
    sha256 cellar: :any,                 sonoma:        "6ad58ee03635189a429e1a8d3e36bec254a1f72a56f41e63f2dcb576b3d4258a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "123584ba3e7bf16d1ad6d79c8f418c399c11597333c7b88636c415065b485e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b3b58345129b261aa27f271fb68ee2bf1eeedeb5fa685132b6938c7a0897998"
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
