class Nlopt < Formula
  desc "Free/open-source library for nonlinear optimization"
  homepage "https://nlopt.readthedocs.io/"
  url "https://github.com/stevengj/nlopt/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "53e552d83e9294d67db37f0f4a23f15933a9ef698485301a18b98b40004cf0de"
  license "MIT"
  head "https://github.com/stevengj/nlopt.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "40617e9ce8f9f757ec76fcd4db8d2340bd82cf1778d05eadfec77a350b7d010a"
    sha256 cellar: :any, arm64_sequoia: "e7fb15da5e5f7c6c775912dd6d1f61717eb32b0f6e82a3a7767e5916e21bec96"
    sha256 cellar: :any, arm64_sonoma:  "c71ce17adc4665fcc9704fb1a906da4211f3f25ef86af8202607c500c4bba4b9"
    sha256 cellar: :any, sonoma:        "cf3cacdc2592ac3496535423c695dbe65e5fea88d1ce44d258667b650ad785e2"
    sha256 cellar: :any, arm64_linux:   "455fafa25c9edb817bb3b31d64369a15f060ae05ed96dd4f0a467a1c2c24b4bf"
    sha256 cellar: :any, x86_64_linux:  "fc367e57d589db083066b92f517e49ee760e9ee1be45082a4b937ae24ac4c6ef"
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

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace lib/"pkgconfig/nlopt.pc", prefix, opt_prefix
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
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
