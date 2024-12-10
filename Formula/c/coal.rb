class Coal < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/coal-library/coal"
  url "https://github.com/coal-library/coal/releases/download/v3.0.0/coal-3.0.0.tar.gz"
  sha256 "6a9cbd4684e907fd16577e5227fbace06ac15ca861c0846dfe5bc81e565fb1e7"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/coal-library/coal.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f153b19d41512585b847003ef4f1586ffb75ed3517da98396e84393aaa27e44e"
    sha256 cellar: :any,                 arm64_sonoma:  "1c506cc8bb8da18b2a51c6fb6e12752168a330b499ee2a0d2935f01743fc11e9"
    sha256 cellar: :any,                 arm64_ventura: "271b8781233c2a06d72a9fee9cb2dca85366f0ae69b4f566c3b770ccfffe74e6"
    sha256 cellar: :any,                 sonoma:        "84f719d46ed7c2c09ca17eac6d7e05c0258faf74f23d95a6a779c06cae35b7bc"
    sha256 cellar: :any,                 ventura:       "31b33f22e75a9afd53c5fe8c4fb2959b62af1e61c9233e11887eb4186222c131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e9bf476dc22586356da2407ee3b2e0efb1985605eaa6cffb18890c11a3e3361"
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
  depends_on "python@3.12"

  def python3
    "python3.12"
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
