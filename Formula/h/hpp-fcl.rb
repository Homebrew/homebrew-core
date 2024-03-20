class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.4.4/hpp-fcl-2.4.4.tar.gz"
  sha256 "cae32b6beb6a93896bf566453e6897606763219cebb3dbfaa229a1e4214b542a"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "acda70b54bf755dc356b03d4bc3297f9a4d5fe66ff7a4de34bf0b1d3c3e30092"
    sha256 cellar: :any,                 arm64_ventura:  "b6039a83cc47acde66f54c44125ef46a6c13915c9ffcb1a708cacee7650ccbbd"
    sha256 cellar: :any,                 arm64_monterey: "cdf308d4db8f056ee7534461325a187a15e6782232d15822534401d86f206e0e"
    sha256 cellar: :any,                 sonoma:         "6c5649f331fd4fc7303adbbb14b1bd4e805202806dfdda5554e6bf96b8a53d78"
    sha256 cellar: :any,                 ventura:        "05aacf9a95016d5e4c71f023c16b042205272394b77148ae01f10c4c7b14b197"
    sha256 cellar: :any,                 monterey:       "dfcf7a7b5fc5bcd23b2052f8700a3cc4de0610ad568394278627654bdc91b476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4920899a1cb1b4ca3bea79d50be116f02d9cfc73cf638564171cfff05e65c906"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "boost"
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
