class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/releases/download/v0.7.1/proxsuite-0.7.1.tar.gz"
  sha256 "8c7f89d2c7a52e157ba5fb20ff2a73117574d7ec629a11f9c5f05b549c59bf7b"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d546a7cd609698f91c6d4c3684f8ea880f60d1dc6c4874529e17bbae7c17d627"
    sha256 cellar: :any,                 arm64_sonoma:  "cb40fd24a5bcc9ec13177b53d773c119c841eb5a72cca96f4d03d1e02bb048f1"
    sha256 cellar: :any,                 arm64_ventura: "c069ce8923f38d1ca4f5cdb31db25cd4117ba2fe9a4d70a6b2933c6b595a31b2"
    sha256 cellar: :any,                 sonoma:        "ae9b59b5e84d7efa3bfd6f3ff3ca550864cc7ff10c3473efa41e4a80d172d145"
    sha256 cellar: :any,                 ventura:       "70fdde88324ecbc6e83a70900c5eefefb59ce7266f1a6b4e4ec581fa22bee591"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f051d245e6c499705c1229f2b46dd52140ca231de2c64a23145c7864393ec364"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "scipy"
  depends_on "simde"

  def python3
    "python3.13"
  end

  def install
    system "git", "submodule", "update", "--init", "--recursive" if build.head?
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_PYTHON_INTERFACE=ON",
                    "-DINSTALL_DOCUMENTATION=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~PYTHON
      import proxsuite
      qp = proxsuite.proxqp.dense.QP(10,0,0)
      assert qp.model.H.shape[0] == 10 and qp.model.H.shape[1] == 10
    PYTHON
  end
end
