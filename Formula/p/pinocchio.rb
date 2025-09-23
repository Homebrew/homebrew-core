class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v3.7.0/pinocchio-3.7.0.tar.gz"
  sha256 "c14c2ac9e5943af9acca9730c31d66c59b57a9407960d5b66d200f50b39a70a1"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "a8dd393229e351e87b15d89185b9a1cdc18054d6b897fea58f6682b18d787d2f"
    sha256                               arm64_sequoia: "eda82cd8f0c0386776d08a58bee6cab180ce611e6c5cb1a2865f84ec3293b8bc"
    sha256                               arm64_sonoma:  "27f25f5d0317089c25e91e32fe6198518f959894797ee38a810a80330b8ae8d8"
    sha256                               arm64_ventura: "cf5349e00902bd01dc2a4f940aa548c11d7132f8a01754b1dbb2e84537bd3972"
    sha256 cellar: :any,                 sonoma:        "dbbf1c937881561fba861e3afafe15f326c387ecbb62c33bcd814d0572b109be"
    sha256 cellar: :any,                 ventura:       "b525d0323bed2db79bb28167d26b95953d0335a424b5b1a3b4bdc7a6df9e83fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e84bdaac5bed9927015891d155c4173ba394e0cfbd87924fe0aa40f60664be8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b590019511af6856fec703aa1ee4eedb9ebd86ce8f8b2bef2484f3dfbbada926"
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
