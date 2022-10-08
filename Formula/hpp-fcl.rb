class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.1.3/hpp-fcl-2.1.3.tar.gz"
  sha256 "8d11f17e0f54e691e03564dd16deca438fd1678188cf98e6c4557587ca1777bd"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "71790f05b54714ff050bbc112cc5e2f1dfea3f02fe9f602d1b383a8af7c06da2"
    sha256 cellar: :any,                 arm64_big_sur:  "e637c9886fbe72a5f6cd0feb9c83291b06b5c097745fb2e286406507c253378b"
    sha256 cellar: :any,                 monterey:       "8a27744bbad8a2ef4e683b712d568d3b0a0ad8ea7c2caf59830812ce3531de9e"
    sha256 cellar: :any,                 big_sur:        "8dddeb1dada479837a384e5c4d0a08e3bda130804b9848558fbbf17ffc296953"
    sha256 cellar: :any,                 catalina:       "1b5d15f020b1287ef4e9dd383c75c8de5d4ec8e54be699d318118b5abee09246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c7527d675a84c83226e99fad32e1ddeba73e3842a184c92576d8e1edbd7880c"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "octomap"
  depends_on "python@3.10"

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.match?(/^python@\d\.\d+$/) }
        .opt_libexec/"bin/python"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{python3}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~EOS
      import hppfcl
      radius = 0.5
      sphere = hppfcl.Sphere(0.5)
      assert sphere.radius == radius
    EOS
  end
end
