class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.1.3/hpp-fcl-2.1.3.tar.gz"
  sha256 "8d11f17e0f54e691e03564dd16deca438fd1678188cf98e6c4557587ca1777bd"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "821fd8af881f90d339ef761de7a6a26b6f196560bac1096798964cfe77c81a3e"
    sha256 cellar: :any,                 arm64_big_sur:  "e8b7f398967271eca2793d9dd4a233a5dd3d75c0d1dd86d3a3b07f3aae86c208"
    sha256 cellar: :any,                 monterey:       "996d5eb6b243caca2bf90d0cce5c32da3ad3dc54681ef8aeac1b2c327a09258b"
    sha256 cellar: :any,                 big_sur:        "d78e5ed90c9ff861313bc0d9779175e0018f98187a57add6c198f5bc3cf1fb5b"
    sha256 cellar: :any,                 catalina:       "318094c42681531d683f67b6a0ed07147e07cf73b11a32d7260029cb98e85c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e919ac84e3d1a58bace9319399dd9663b37e07b42f25ef2ea106b29b6674cf6d"
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
