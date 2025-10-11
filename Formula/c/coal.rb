class Coal < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/coal-library/coal"
  url "https://github.com/coal-library/coal/releases/download/v3.0.2/coal-3.0.2.tar.gz"
  sha256 "899eb343ee7d86ae6312401bc969d1d2cb8103a5a67af5e1f06061a9c5fb0743"
  license "BSD-2-Clause"
  head "https://github.com/coal-library/coal.git", branch: "devel"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c4e7f8a9652bc96e3bee148c7511020ae0a6408e5c53e852a1f16ed59d28d79e"
    sha256 cellar: :any,                 arm64_sequoia: "ee7098a0fc28c6230b173b65b2e41fd168648d8da56b6c0909d022f80637f114"
    sha256 cellar: :any,                 arm64_sonoma:  "2d1e953a9ef87494e1bd129171db52817e7b33e5364eea301de9fbf0962b3671"
    sha256 cellar: :any,                 sonoma:        "fa1c9951d3f6bd5c8814ae5d065d3897aa2b1db664a5e8d7381866938a4501fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67d32a04ed7fddfb1e5f505e9f6cf84566e926943caf6fa1f417e8015e514236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "270e805707fa846a78e1d267fc20def7c2615a8eb71ec9de3da9ea53da3ead9a"
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
