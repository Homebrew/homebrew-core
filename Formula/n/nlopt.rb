class Nlopt < Formula
  desc "Free/open-source library for nonlinear optimization"
  homepage "https://nlopt.readthedocs.io/"
  url "https://github.com/stevengj/nlopt/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "30d13ce16da119db3e987784f7864e35a562ec62c186352fae55cd003e6c58ff"
  license "MIT"
  head "https://github.com/stevengj/nlopt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "895d8e1a5b7257380f335c5992c674660a122c64ee1d67eea566e65cdb1e0b84"
    sha256 cellar: :any,                 arm64_sequoia: "9773396412cfffe1c6dc4a3c2f1f82d32c8da396ac44733b7e117d20a15166ef"
    sha256 cellar: :any,                 arm64_sonoma:  "97e616890c809b51cbe8a8efffa8fe3ef6d69a319d7fbd7253d9738064c919f8"
    sha256 cellar: :any,                 sonoma:        "c468957d29935740a3e7bf6248709d088b7876f944379c3f33bf65c38b7fba47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce2cfb1d74dfb5f66022516311d416acacf8beb7186dcc89fbe0f975c1eb6a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca3f9218108faa8cf151c88d784b7af7a090162f2efea0085d358eeb4164b5df"
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
