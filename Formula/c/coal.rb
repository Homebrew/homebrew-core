class Coal < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/coal-library/coal"
  url "https://github.com/coal-library/coal/releases/download/v3.0.4/coal-3.0.4.tar.gz"
  sha256 "0a9091aa281f51b9513f11aae39758a6188bca63010524f36b3bdc566381ca4a"
  license "BSD-2-Clause"
  revision 3
  compatibility_version 2
  head "https://github.com/coal-library/coal.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "c279e603ab476222cd5e633351d9e5a2f9c2e12aba14a68987f490b2e91b6fed"
    sha256 cellar: :any, arm64_golden_gate: "f1dade4205910ef0486c65613a4ac4a0a65e7559d02320c9b6ca9ab1545c77ee"
    sha256 cellar: :any, arm64_tahoe:       "e896f2db34c07fd5e8068da02275b5061c2b032e3572dc4d7177f6621fbb9309"
    sha256 cellar: :any, arm64_sequoia:     "d90ba638503e0e7bfc50030347a89bcd6b12902a6f0efe4383b6868f6c5794e2"
    sha256 cellar: :any, arm64_linux:       "c836308dafbd3414427034cd132d65f3127688e85be95f176e39bb50e6238e71"
    sha256 cellar: :any, x86_64_linux:      "aebe31571367eabb9855167eada5a173d875f39eb3e84b04871607d4cd852fb1"
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
  depends_on "python@3.15"

  deny_network_access!

  def install
    ENV.prepend_path "PYTHONPATH", formula_opt_prefix("eigenpy")/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    # FIXME: octomap 2 only accepts 2.0.x version requests, so drop the 1.8 minimum until coal supports octomap 2
    inreplace "CMakeLists.txt", "ADD_PROJECT_DEPENDENCY(octomap 1.8.0 ", "ADD_PROJECT_DEPENDENCY(octomap "

    # enable backward compatibility with hpp-fcl
    args = %W[
      -DPYTHON_EXECUTABLE=#{python3}
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
