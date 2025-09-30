class Nlopt < Formula
  desc "Free/open-source library for nonlinear optimization"
  homepage "https://nlopt.readthedocs.io/"
  url "https://github.com/stevengj/nlopt/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "506f83a9e778ad4f204446e99509cb2bdf5539de8beccc260a014bd560237be1"
  license "MIT"
  head "https://github.com/stevengj/nlopt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a6812d6b611b71abaae05550adb9ee32a76a5d9589a130262ec005d2e8c15a55"
    sha256 cellar: :any,                 arm64_sequoia: "4b5cfef104d5816a719d35624642efd027d4d4dedfd21e67ae26eed7ceb1d9d6"
    sha256 cellar: :any,                 arm64_sonoma:  "a09deedc38d8d4d44c105c4c1c603fdf0652d9e5506885c04586ec2d25df650b"
    sha256 cellar: :any,                 arm64_ventura: "e401c6382cc8b7d25ea8095554443a881fa0cb02e935b7dfd5eece47d7429df8"
    sha256 cellar: :any,                 sonoma:        "53909c4a84848ff62246d64f07df563bf63afc5076b05a6fde82e3e9095f85cc"
    sha256 cellar: :any,                 ventura:       "3d1d6b2321c6999b121cc84e40f066f8a909a652dadbc7e0ae3e438155d977fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "633654bcc4170038a67d07575d365a02e470ced5d15d97c098460c522adf09c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b98fc2b074ae63ce6fbbedce14c22165c7cd91c661895c9f36aa9aeccf3fe790"
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
