class Coal < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/coal-library/coal"
  url "https://github.com/coal-library/coal/releases/download/v3.0.3/coal-3.0.3.tar.gz"
  sha256 "d1afcc0c22477a61e93e070a01cc8ed1d256a96ec65d308844d24b9caf771d36"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/coal-library/coal.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7fe4df0b934288e12efb12f02ced3be04048554ec4dbb5443d82f8e75e6e316"
    sha256 cellar: :any,                 arm64_sequoia: "0ce2c1748d1a38984096d874ea55d77e876765baaf4369d85e31ec5af334caba"
    sha256 cellar: :any,                 arm64_sonoma:  "480d1274af46ebf2654d8a74c9b6af5b3eb0f47dd5a53a9b32fa010d55da5675"
    sha256 cellar: :any,                 sonoma:        "5b6f314be22e5c0364cf100fdc54811bd9fe34d9070b6cd73eec12a49937225c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f49f1616f37151a19ef15beffe6383aaec0c45d8464ab6c2d8ab4dda1e007c69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88cd0bfd149b14bac9666ac6609dfc76ef7314bbbe098a5c541c5eb463cc94cd"
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
