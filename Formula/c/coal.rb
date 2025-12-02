class Coal < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/coal-library/coal"
  url "https://github.com/coal-library/coal/releases/download/v3.0.2/coal-3.0.2.tar.gz"
  sha256 "899eb343ee7d86ae6312401bc969d1d2cb8103a5a67af5e1f06061a9c5fb0743"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/coal-library/coal.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea2e9ddb3b82550873fc31804dc8c22238d53d2142e73fb64d66b61dc603a614"
    sha256 cellar: :any,                 arm64_sequoia: "6f120192065eff865e85cbe4b60e0c5a8ac444aa00af0a3e3d3cc85b4445b9c5"
    sha256 cellar: :any,                 arm64_sonoma:  "5f2d9e5e74b679dc2d6ace787f9db7592b13d41dbcf49efc04c6c942b2be00a7"
    sha256 cellar: :any,                 sonoma:        "8ac75a9345115b33e7f40877e21679db8092653df4af3a0c60ee36d7b6e5fd09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdb978552dd20e4a493c30b00c8eff2ce83ea54d848d631e33c9f8b9ec29e6a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bbc8e8cfb74069c0b95ecccbfe8b4e731c4265eb483b1f7d3013925c769d984"
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
