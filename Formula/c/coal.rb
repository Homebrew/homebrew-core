class Coal < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/coal-library/coal"
  url "https://github.com/coal-library/coal/releases/download/v3.0.1/coal-3.0.1.tar.gz"
  sha256 "b9609301baefbbf45b4e0f80865abc2b2dcbb69c323a55b0cd95f141959c478c"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/coal-library/coal.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "93c89b2873259086699a57459a415d65ddd1dfce265bd6c7de2ee8363eb150b7"
    sha256 cellar: :any,                 arm64_sonoma:  "9f81a45edd66ba140010c12490a6eb8b80ca8a54d6f83543493114196fb7f84a"
    sha256 cellar: :any,                 arm64_ventura: "620f933d21f49c2c6bf839d51fec7a422b121954a1ab38afee108a23be4bf384"
    sha256 cellar: :any,                 sonoma:        "f72dc67fe2f95b217a2c38e24f1d4f72c9a2bc65df0e0d71673fe1186a054f4f"
    sha256 cellar: :any,                 ventura:       "7c7b5a8a8333d93f7dcd39f71c34c1c647c9c4f9d699d7dcccb6d3fbb0024eb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96cf06bd85207f780e6129df13d3c39fa76849dd9ffd5b200910905af72bfbc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0df7e903422fecd27c66c998d6b7ed694292527e5089d973bf6d75635ec60ce"
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
