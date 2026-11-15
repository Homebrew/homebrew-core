class Coal < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/coal-library/coal"
  url "https://github.com/coal-library/coal/releases/download/v3.0.4/coal-3.0.4.tar.gz"
  sha256 "0a9091aa281f51b9513f11aae39758a6188bca63010524f36b3bdc566381ca4a"
  license "BSD-2-Clause"
  revision 2
  compatibility_version 2
  head "https://github.com/coal-library/coal.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6659ecec2b29e75f6d2e1436231b6cb55b761a0174eee94a885726678016e4c2"
    sha256 cellar: :any, arm64_tahoe:       "759bf90f11ecd64c433ef03fb5e6b0501f217e096fd6609a86b8882c3a92e64c"
    sha256 cellar: :any, arm64_sequoia:     "2d12d563732f474726880e9f63a98dd32c458c3be361b331b98cfa19785804e4"
    sha256 cellar: :any, arm64_linux:       "39f05a3b92125ed78d3649d9d05afa200e83c886f397bcdbdabcff91acb95cc8"
    sha256 cellar: :any, x86_64_linux:      "dfb9ce4eeb055e2c21991567b6dd68b41b50f1851aedf9dba4dcfd44ca0fcb66"
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
