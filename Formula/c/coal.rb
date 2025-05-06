class Coal < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/coal-library/coal"
  url "https://github.com/coal-library/coal/releases/download/v3.0.1/coal-3.0.1.tar.gz"
  sha256 "b9609301baefbbf45b4e0f80865abc2b2dcbb69c323a55b0cd95f141959c478c"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/coal-library/coal.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e2d87ef2038acd5dcf9756b87f66d478603dcf2e98bc7eba3aa8ed2455a326ad"
    sha256 cellar: :any,                 arm64_sonoma:  "f2ef50d3e832c5c63512cb927cc5a7a9e8624f9aa045e58a1433b62e54d9b295"
    sha256 cellar: :any,                 arm64_ventura: "5915881cfc9032d711eba837fdbaa076ab45b23dffce110114778a2e65d6ce2a"
    sha256 cellar: :any,                 sonoma:        "28b03d78e18bca9541c8a186667a2cd59d9bf00c63011c7128af67451e7cb019"
    sha256 cellar: :any,                 ventura:       "51a4cd079554920b83c11f3177af2b2e4aa6d8496384dea819ada476163ab09f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7a0eee745edc2ab275d7e4ae8fa3a7a4f8cf565da49e94c7a51d6aedb6367ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3909470b234c0176b176fc89c8378c2f778450cadadfe96cdf4a604d4534c5f"
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
