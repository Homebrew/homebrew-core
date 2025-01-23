class Nlopt < Formula
  desc "Free/open-source library for nonlinear optimization"
  homepage "https://nlopt.readthedocs.io/"
  url "https://github.com/stevengj/nlopt/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "1e6c33f8cbdc4138d525f3326c231f14ed50d99345561e85285638c49b64ee93"
  license "MIT"
  head "https://github.com/stevengj/nlopt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dde3448448cfcab26c78ee3297ff3a108990cd5ad6e7ce51c75bec01b0b80f67"
    sha256 cellar: :any,                 arm64_sonoma:  "141948dfbf37d2598acf237f30f249a8c350a731b8fa0989f9d3764e39a33018"
    sha256 cellar: :any,                 arm64_ventura: "14eab9b8b46a24fd3074f843a64bc65445cac18c344dcb598db05662069b10c7"
    sha256 cellar: :any,                 sonoma:        "47ec9a4f7cd5d583479fc5de4e26c7cba0ab1a7a352851a19dd11c542700c918"
    sha256 cellar: :any,                 ventura:       "e5554d8ee37a66b7c7bf61b1071b28cf323aeea4b9973a11160b60bcecc5d3d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aef777322e668f27597d9801736b270d74a017a607d2d5fa310787b0916bf38e"
  end

  depends_on "cmake" => [:build, :test]

  def install
    args = %w[
      -DNLOPT_GUILE=OFF
      -DNLOPT_MATLAB=OFF
      -DNLOPT_OCTAVE=OFF
      -DNLOPT_PYTHON=OFF
      -DNLOPT_SWIG=OFF
      -DNLOPT_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test/box.c"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.0)
      project(box C)
      find_package(NLopt REQUIRED)
      add_executable(box "#{pkgshare}/box.c")
      target_link_libraries(box NLopt::nlopt)
    CMAKE

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    assert_match "found", shell_output("./build/box")
  end
end
