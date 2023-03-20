class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v15.0.0.tar.gz"
  sha256 "6680424f80c5731a85d977c06327096afe5af31da3667e91d4d36a25fabdda15"
  license "MIT"
  head "https://github.com/halide/Halide.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a73a5036caf2ebf5d15664613ce1276d14cd2e89d86ea8a1f3ee939a97eac055"
    sha256 cellar: :any,                 arm64_monterey: "5fb04685717aa407a23f1deda52aa464fbffb15a49a39e17294f205d60361724"
    sha256 cellar: :any,                 arm64_big_sur:  "a0bb91a4ddd4cde66f27cde5fb821f1168b752aaf3668522b685435172d64753"
    sha256 cellar: :any,                 ventura:        "82e2e17d477547b3f663edbc7e4a40a8f459e705465e10a4fc3f7645b519effe"
    sha256 cellar: :any,                 monterey:       "809462ea46cbc33395e499fbd1507bffa8d801a8e88003643df5daac7c119b1c"
    sha256 cellar: :any,                 big_sur:        "bdc98190beba09044796de180b48aa1b719dabc45e221ef584f223585b73df40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b4262929abb83409d12158247d441f3e6429371f851c300745b9fd2448e339f"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "llvm"
  depends_on "python@3.11"

  fails_with :gcc do
    version "6"
    cause "Requires C++17"
  end

  def python3
    "python3.11"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DHalide_INSTALL_PYTHONDIR=#{prefix/Language::Python.site_packages(python3)}",
                    "-DHalide_SHARED_LLVM=ON",
                    "-DPYBIND11_USE_FETCHCONTENT=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp share/"doc/Halide/tutorial/lesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++17", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output("./test")

    cp share/"doc/Halide_Python/tutorial-python/lesson_01_basics.py", testpath
    assert_match "Success!", shell_output("#{python3} lesson_01_basics.py")
  end
end
