class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v4.1.0/pinocchio-4.1.0.tar.gz"
  sha256 "b2ac9575bd4f38e0584e0d61586a95de1aeaa17c6877e31e99f1d4b913d602d8"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "72a89c2ca8b04a1dfcd889a447e9a72df9851a8039807f34bd98f9222db37c6b"
    sha256               arm64_sequoia: "cf071e753353e646a37d9aa3f6425af200031b0373cdc75178558851a6aa0842"
    sha256               arm64_sonoma:  "76f121231baca17770c4d46a832c89c08aecca1b1fd140258b222c67fcc5a4f1"
    sha256 cellar: :any, sonoma:        "8040528fc0e39c079058d46fd0d65a38419898678164bb82518a49566f9457f1"
    sha256 cellar: :any, arm64_linux:   "eb08dc1ac1e3c7bce6939104ac18bf850c38a587db3f5e0a5c6ccdff8c8a4f70"
    sha256 cellar: :any, x86_64_linux:  "eea38ba8f243785c38eb0820eab9cc5ce400fd03cfb90bcc2f61cb1d17a80871"
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
