class Coal < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/coal-library/coal"
  url "https://github.com/coal-library/coal/releases/download/v3.0.2/coal-3.0.2.tar.gz"
  sha256 "899eb343ee7d86ae6312401bc969d1d2cb8103a5a67af5e1f06061a9c5fb0743"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/coal-library/coal.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fd213abe328948a7c9911a43373ed8046d0710fb8a0a9889d2d6ff11bbf4b73f"
    sha256 cellar: :any,                 arm64_sequoia: "320c09dd888c1d2c9d670ca2e2277fb25fcb0692ab4f83ad6cc6350d77f2f46d"
    sha256 cellar: :any,                 arm64_sonoma:  "27de2e1a650fd1690c675c756b04e72175c40a818fd874467f1d3a157f7364d2"
    sha256 cellar: :any,                 sonoma:        "087d9dabc09adca03410b614932ad56798a671c6ee52aad74ddafd63ffdc4192"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9567a4db7fe0a8cfc17a0ba7d5a5f9d2d1d58002cf07675480d5c1746ce50e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d396d1e1014d58558ab9f2a9e560845ee86dbfa429d2511a95776780894372a"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "octomap"
  depends_on "python@3.14"

  # Workaround for Boost 1.89.0 until upstream fix.
  # Issue ref: https://github.com/coal-library/coal/issues/743
  patch :DATA

  def python3
    "python3.14"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    # enable backward compatibility with hpp-fcl
    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DCOAL_BACKWARD_COMPATIBILITY_WITH_HPP_FCL=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    %w[hppfcl coal].each do |module_name|
      system python3, "-c", <<~PYTHON
        exec("""
        import #{module_name}
        radius = 0.5
        sphere = #{module_name}.Sphere(0.5)
        assert sphere.radius == radius
        """)
      PYTHON
    end
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index ec28225..cdbcddc 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -167,7 +167,7 @@ if(COAL_ENABLE_LOGGING)
   ADD_PROJECT_DEPENDENCY(Boost REQUIRED log)
 endif()
 if(BUILD_PYTHON_INTERFACE)
-  find_package(Boost REQUIRED COMPONENTS system)
+  find_package(Boost REQUIRED)
 endif(BUILD_PYTHON_INTERFACE)
 
 if(Boost_VERSION_STRING VERSION_LESS 1.81)
