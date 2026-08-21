class Coal < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/coal-library/coal"
  url "https://github.com/coal-library/coal/releases/download/v3.0.4/coal-3.0.4.tar.gz"
  sha256 "0a9091aa281f51b9513f11aae39758a6188bca63010524f36b3bdc566381ca4a"
  license "BSD-2-Clause"
  revision 1
  compatibility_version 2
  head "https://github.com/coal-library/coal.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "495cdffb94bd2ade436176c1bd351c3c4fc78db6ecab39870efa080322253f24"
    sha256 cellar: :any, arm64_sequoia: "6b5394dc00cd7799e76ff788967d781bf5df4b9218e3fbb773e2be967eeadce8"
    sha256 cellar: :any, arm64_sonoma:  "09cb242a343665a4dd26e03bad28d2f2aa5d030b1ec05c713feb52983a252e46"
    sha256 cellar: :any, sonoma:        "1c2fbb8235fae840e539ed6e5e4f4e408f3429a280869b63a2fe0354323d1b8b"
    sha256 cellar: :any, arm64_linux:   "02bb279ea8edf73cd667d3d4fecfe038ed5f9418da1d960230e0f9e54ac50f59"
    sha256 cellar: :any, x86_64_linux:  "c7bb161695df442bfe9bbb3612c3753e9aaf086e160b4da4771d1474149c8a23"
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
    ENV.prepend_path "PYTHONPATH", formula_opt_prefix("eigenpy")/Language::Python.site_packages(python3)
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
