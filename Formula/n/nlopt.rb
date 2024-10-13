class Nlopt < Formula
  desc "Free/open-source library for nonlinear optimization"
  homepage "https://nlopt.readthedocs.io/"
  url "https://github.com/stevengj/nlopt/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "e02a4956a69d323775d79fdaec7ba7a23ed912c7d45e439bc933d991ea3193fd"
  license "MIT"
  head "https://github.com/stevengj/nlopt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6cc504a8ae9faaa179ccdc53f2c60e798d094171bfaf8cccd6b2b21daaeb29f5"
    sha256 cellar: :any,                 arm64_sonoma:   "20f0cac5105fa0ddc82842091aeb29a1efa7ad3f3a6ef6141f6fb733d0a51175"
    sha256 cellar: :any,                 arm64_ventura:  "c1d084e9e02aeea9590837a4f589c5366809bb0b2a8ffa89db52a547fb587b81"
    sha256 cellar: :any,                 arm64_monterey: "bc0304fa0a34d1331a3114d06cbeae705625ca482f3412bd89880b7d7ca4a061"
    sha256 cellar: :any,                 sonoma:         "79efb55e1183b61a70e6ae3a976fadb8c2f63da6af7ed84bc4e88ad43ced3b4c"
    sha256 cellar: :any,                 ventura:        "1cacc860d735502e1557cbfce2822acf99b2c54f256717801bb87af4bb2c87d9"
    sha256 cellar: :any,                 monterey:       "748a39a74580c9985953d94b6fccfaf79f7070a27835cc8225c848987dd79576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f51af4ef62578c001a8967c868d2206e54e35f0226d2296c2aa13a86fee4d82"
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
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.0)
      project(box C)
      find_package(NLopt REQUIRED)
      add_executable(box "#{pkgshare}/box.c")
      target_link_libraries(box NLopt::nlopt)
    EOS
    system "cmake", "."
    system "make"
    assert_match "found", shell_output("./box")
  end
end
