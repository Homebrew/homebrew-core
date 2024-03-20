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
    sha256 cellar: :any,                 arm64_sonoma:   "0ffe130c8c80891fa02077b5aa863b6dac5958299d8e75f0eee65b777e677970"
    sha256 cellar: :any,                 arm64_ventura:  "bc06b0a9244177ac2a4a6c21c0ed8b0369a8aa9c2850fa5c814325e362788026"
    sha256 cellar: :any,                 arm64_monterey: "75c8628ee6958a2f6274be635fdbb7d139a8e02b7efd55d3cfd7cf3ae0cf817b"
    sha256 cellar: :any,                 sonoma:         "a8848b73ae4336ba42226bd5b10bf44e6247dba354bb6f1888c82ac5877b1023"
    sha256 cellar: :any,                 ventura:        "728f4df16fafccc36af5c6cf988ca01947a8906dea6fabf1e6c03743938495d5"
    sha256 cellar: :any,                 monterey:       "0b8befae70922c35fa0155cde51919cc012a0d32ba9bc885400a81872ba8f403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97617426f9b53d0823bb274ffab4e0c125b6fbe26d8bb29deefba416351ffb23"
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
