class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.4.5/hpp-fcl-2.4.5.tar.gz"
  sha256 "14ddfdecdbde323dedf988083e4929d05b5b125ec04effac3c2eec4daa099b43"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4f1ec99f9d8979f3faafd5456572a215ac0a5a9a3c366a298dd5a2684ba7a06d"
    sha256 cellar: :any,                 arm64_ventura:  "44e0f677fc4e9b826344f1e0aae4b83e90ce8b4b97220fef024bfa6449c0ffa2"
    sha256 cellar: :any,                 arm64_monterey: "e7b5252296d17b6307f0166ac3354dcf3e6e12a23631463cd8866197503150ea"
    sha256 cellar: :any,                 sonoma:         "7f1c45f3a186b5135e1e930172f5f72eeaab785c1868f38ce1f11be192edd150"
    sha256 cellar: :any,                 ventura:        "5dae706cc6e2bbab5a8a3160f60c84fa9c73806889ad537ca868f2796e044631"
    sha256 cellar: :any,                 monterey:       "ecc514bc091a2de6673823758fd2ffb5717b9c9f03c2c5356a234691c8fe6f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5366ba3235067a32046ac9dc20356124ffd6402877fe4d35040172bf27268e3a"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
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

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
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
