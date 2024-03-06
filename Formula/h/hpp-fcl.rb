class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.4.4/hpp-fcl-2.4.4.tar.gz"
  sha256 "cae32b6beb6a93896bf566453e6897606763219cebb3dbfaa229a1e4214b542a"
  license "BSD-2-Clause"
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f1a52d62030d8abbc1389da1eff235479618c847d326d0e44982d7a1331ff1f1"
    sha256 cellar: :any,                 arm64_ventura:  "208eed7bede0fd5be86f4af68bee18dc3861b6a199f2f5c15381e14b18bcdc5f"
    sha256 cellar: :any,                 arm64_monterey: "1c6ba325e5d86fa9a6c145b026ac4a5dfe221be2aeb841d1c2d86562b95b3911"
    sha256 cellar: :any,                 sonoma:         "b59b1e4206077007015f25aad5c4b8e39248fa737015cfddebc20b497ab5d1de"
    sha256 cellar: :any,                 ventura:        "4fdbcb06ce038f88fed72050908f514d548da2d54ecd9eacaaa24b80da743337"
    sha256 cellar: :any,                 monterey:       "939c7a4f7a2e3bcaa1fffe26c560d51dd56370138fe5d6b2a840e325e5c03ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b09e5b88bd4b2349025ac3456228e78c62c113476fa8cf8edc33034728b4c99"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "python-lxml" => :build
  depends_on "python-setuptools" => :build
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
