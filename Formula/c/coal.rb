class Coal < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/coal-library/coal"
  url "https://github.com/coal-library/coal/releases/download/v3.0.1/coal-3.0.1.tar.gz"
  sha256 "b9609301baefbbf45b4e0f80865abc2b2dcbb69c323a55b0cd95f141959c478c"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/coal-library/coal.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3dd6e805964cd404e8eb00f9fdf17cd7bb56aabb97296aa3f6449a9c7624646d"
    sha256 cellar: :any,                 arm64_sequoia: "3f7ed10af05493f7a2992a98efb2c983004e2b167cd389c43d5feea319da1497"
    sha256 cellar: :any,                 arm64_sonoma:  "7dab1289d5931423e4c9c88d1a8b6487e6b7c37c058b2afe7e6c3eb4edc0f75b"
    sha256 cellar: :any,                 arm64_ventura: "50b83e1c52071435771a9c1af840e63fb08a29e681bfdacff8fab9a93df8ccf4"
    sha256 cellar: :any,                 sonoma:        "4672c87f581b46684c487af03ff08154c2fa9c230b78a5da4b9a0a46f4d5cc77"
    sha256 cellar: :any,                 ventura:       "572df15279e19d26d3eb5122aeed97bdca259c4f3188ce888f5601e241854aba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f24056b7759b6e17c89cd229595a511b922763fcf3aca52783af98234f4df74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cad2991102527882a216feedd179879dc74ceb85879773d8a4e76191c70eeb60"
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
  depends_on "python@3.13"

  # Workaround for Boost 1.89.0 until upstream fix.
  # Issue ref: https://github.com/coal-library/coal/issues/743
  patch :DATA

  def python3
    "python3.13"
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
index 4036e3c1..11b6b8d8 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -151,7 +151,7 @@ if (COAL_ENABLE_LOGGING)
   ADD_PROJECT_DEPENDENCY(Boost REQUIRED log)
 endif()
 if(BUILD_PYTHON_INTERFACE)
-  find_package(Boost REQUIRED COMPONENTS system)
+  find_package(Boost REQUIRED)
 endif(BUILD_PYTHON_INTERFACE)
 
 if(Boost_VERSION_STRING VERSION_LESS 1.81)
diff --git a/python/CMakeLists.txt b/python/CMakeLists.txt
index 38b98031..8107bf7d 100644
--- a/python/CMakeLists.txt
+++ b/python/CMakeLists.txt
@@ -143,7 +143,7 @@ ENDIF()
 TARGET_LINK_LIBRARIES(${PYTHON_LIB_NAME} PUBLIC
   ${PROJECT_NAME}
   eigenpy::eigenpy
-  Boost::system)
+  )
 
 SET_TARGET_PROPERTIES(${PYTHON_LIB_NAME} PROPERTIES
   PREFIX ""
