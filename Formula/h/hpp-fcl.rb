class HppFcl < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https://github.com/humanoid-path-planner/hpp-fcl"
  url "https://github.com/humanoid-path-planner/hpp-fcl/releases/download/v2.4.4/hpp-fcl-2.4.4.tar.gz"
  sha256 "cae32b6beb6a93896bf566453e6897606763219cebb3dbfaa229a1e4214b542a"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/humanoid-path-planner/hpp-fcl.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "02f037ea0dae5edbc21ad772e97bb5c4fd09d7c6b28d841aa3c7cb78148580de"
    sha256 cellar: :any,                 arm64_ventura:  "ff94e1ea4d9d8dcb335b7e2e4a1b5ed9942c3aa3567d4acb7b4cb6f50157483b"
    sha256 cellar: :any,                 arm64_monterey: "27578e0e0087c582d84dba4b0a62179c4909ca863ee9c12906ced694725b03dd"
    sha256 cellar: :any,                 sonoma:         "dbbf62bedb5f23c069b5c788ab08358fc5096f2038822435b32a41ab6ca4d5b2"
    sha256 cellar: :any,                 ventura:        "a9beffd89b40b1fcbbc25ed87d84cea02f949d8ae99cd3a39b92ed6d4158a2ab"
    sha256 cellar: :any,                 monterey:       "63284f50a9ccb8ba1610e708a3cf3e4218699b127b3f3057df716a8db5519e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a897805a17a5365b9fa42f512eff70ffe7fd735acc5a73f489e240231c83203"
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
