class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v3.8.0/pinocchio-3.8.0.tar.gz"
  sha256 "aa4664d95a54af7197354a80f5ad324cb291b00593886b78dd868b1fd13636ca"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "c240dc4a96196bb13d55508582441854d944e0c1189285f87f2620ef3f9ab9a3"
    sha256                               arm64_sequoia: "3b743220ccb4a9f80f2d7dfa06981188fb1d7b960b7bc673659abcba32f30b82"
    sha256                               arm64_sonoma:  "5b7e5a57614e09d7b9e5444111c79b0e57dc996f00c8e7ebccccb5baa1f001b6"
    sha256 cellar: :any,                 sonoma:        "fd13fc7b9fcde2a4d3e7d527d4fb9b8feb444af6c42014c73f4c7ff15c9a9b57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5648b2ad9953c79d1d8c32e8c12e4c9323b64da1614606fd9a7cf9a46760bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d45a35b27e9433f3437b9a751bc5d212e21d0d2972d6c3f7a332da52e14d2f59"
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

  # Workaround for Boost 1.89.0
  # TODO: Report upstream
  patch :DATA

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
