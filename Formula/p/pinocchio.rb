class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v3.8.0/pinocchio-3.8.0.tar.gz"
  sha256 "aa4664d95a54af7197354a80f5ad324cb291b00593886b78dd868b1fd13636ca"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "98b6f465c0e9d35d4d5aeb95c9fe3e2248e6f42bf422e94cd4e09c210016f27f"
    sha256                               arm64_sequoia: "b1143e077fad5bd8fd7d3467ad3ee20a4ddc5ff9b9e10b9f79c551f79ac490d6"
    sha256                               arm64_sonoma:  "066c9d7e969c73d1f912680beb3e3670f3e3bbdb0dac552c79eaf1ea1960fe1e"
    sha256 cellar: :any,                 sonoma:        "037916541261b61dbe602b59aba88eccc2b299e16829c2336e2bddd2badaf0d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f69d519e136bb03a01bb868ec2f25f2c3a9f91539bd0aec19d4eff51b11c633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a9a3fd0ce7d1891f9cd35be59cd35280986e7afeb309502cc7fc3e3dfb0b06f"
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
  depends_on "python@3.13"
  depends_on "urdfdom"

  on_macos do
    depends_on "octomap"
  end

  # Workaround for Boost 1.89.0
  # TODO: Report upstream
  patch :DATA

  def python3
    "python3.13"
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

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 67dd06db..5fbe52be 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -286,7 +286,7 @@ if(BUILD_WITH_EXTRA_SUPPORT)
   message(STATUS "Found Qhull.")
 endif()
 
-set(BOOST_REQUIRED_COMPONENTS filesystem serialization system)
+set(BOOST_REQUIRED_COMPONENTS filesystem serialization)
 
 set_boost_default_options()
 export_boost_default_options()
