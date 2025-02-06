class Nlopt < Formula
  desc "Free/open-source library for nonlinear optimization"
  homepage "https://nlopt.readthedocs.io/"
  url "https://github.com/stevengj/nlopt/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "506f83a9e778ad4f204446e99509cb2bdf5539de8beccc260a014bd560237be1"
  license "MIT"
  head "https://github.com/stevengj/nlopt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5bc45b441a6db3d2a2bd91872a88181b73ec43855f8724251706928810099d53"
    sha256 cellar: :any,                 arm64_sonoma:  "56399d4d815f50ab2dd09e77c6e967ce6c1b45cab6377ab319001b1a8840598c"
    sha256 cellar: :any,                 arm64_ventura: "fcc202f3741a7b3702fd3f3acf6ac7b9350aeb7b006dd302efc8b9f81e90df57"
    sha256 cellar: :any,                 sonoma:        "4047f0326b06f45eb780edfadf5a22e39e59d9e5474fd0efaafa06d6d233ec2b"
    sha256 cellar: :any,                 ventura:       "997538dd9a34c8c7611bcb874567aaa0cb3d3eda6a8a2da85c61bf712df3907f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f545f273dd2d6d583e2acc54b5ad93a7a6d8a53810f3e9cbab05fed1aba6893a"
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
