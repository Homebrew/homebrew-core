class Coal < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/coal-library/coal"
  url "https://github.com/coal-library/coal/releases/download/v3.0.0/coal-3.0.0.tar.gz"
  sha256 "6a9cbd4684e907fd16577e5227fbace06ac15ca861c0846dfe5bc81e565fb1e7"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/coal-library/coal.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f6334d35e66e1d9db8d3d598ff339037bb0b0bc25032789967c3ba0f9c191d8a"
    sha256 cellar: :any,                 arm64_sonoma:  "f7d995046472136d5d4e4fb5510a51e9ab927632d471ebd78fb7e28c13ed2bfc"
    sha256 cellar: :any,                 arm64_ventura: "3098293312c10df220f47dcb0086f079eb3ac332b20479b829127e06ae6a1bfb"
    sha256 cellar: :any,                 sonoma:        "50ad666c545054c491fea1c0dfe2246d40cb36c8c8a4fb5c3f61f4f7b727f115"
    sha256 cellar: :any,                 ventura:       "3e6347ac04bd3ddb3464956bb3469391db494f009f677818b27e43f464f73248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2af1b52ae484df6821cd02ce5a93678119fdc3b7423e8ac9c0d087f6fafc626"
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
