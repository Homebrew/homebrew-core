class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.2.0/hpp-fcl-2.2.0.tar.gz"
  sha256 "deb3d8becbd47258e3b327f6025f581007b4ae7047a38e0a32f524bbdb74d489"
  license "BSD-2-Clause"
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "166ac2aeef198f5ecd89c840f9110eeeef1cdaf5f77aab5c088dd7f052894450"
    sha256 cellar: :any,                 arm64_monterey: "31709a9fe99cec28ad6fd9568f54c2a4727a1028e7fad6e622e03315302c377b"
    sha256 cellar: :any,                 arm64_big_sur:  "2d7a742daf3bf436562daa8f2e3e051e5e529070dbcd33613ae8ad730ee86880"
    sha256 cellar: :any,                 ventura:        "23eadfbb6eb1936e062aa53a9636337333ed587ce171ebad9760731e54799a92"
    sha256 cellar: :any,                 monterey:       "fd60746bf97abf46da4b61666c75b486ddfe92c5158a16785485f785a3549766"
    sha256 cellar: :any,                 big_sur:        "082caaecc1571aaafbdcb63aa13aa8814eefe1cd991a34e42aff4357c98a6bc7"
    sha256 cellar: :any,                 catalina:       "99f67017a177a7766c95db47d1b58bbee407dfd82b7df911f2c6989d7a4a631a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f92b15216736fde3087cc0e159ed14362ab7fdac1298b50627fd49b9efd6834"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "octomap"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
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
