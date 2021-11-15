class G2o < Formula
  desc "General framework for graph optimization"
  homepage "https://openslam-org.github.io/g2o.html"
  url "https://github.com/RainerKuemmerle/g2o/archive/refs/tags/20201223_git.tar.gz"
  version "20201223"
  sha256 "20af80edf8fd237e29bd21859b8fc734e615680e8838824e8b3f120c5f4c1672"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c492d099917d4f2a22b8b11095580fbd14de561942d048727e4069316832dfbb"
    sha256 cellar: :any,                 arm64_big_sur:  "161de612759ffe32652d1eac931b72f8f3c7d1a9807acd9e7215459430df3eec"
    sha256 cellar: :any,                 monterey:       "e8d94c808de15df0286bf9337a17cf5c21935b6a9da55ad993560225c3d36623"
    sha256 cellar: :any,                 big_sur:        "b99527b4e0670ced76af5ad443df1b83d3c3a16a84b9a834be849336e76d99fc"
    sha256 cellar: :any,                 catalina:       "8d8d1b729449d5f6e5afd9ef70aa2531e75e60f2a3208dcfdf00ca3097e146c4"
    sha256 cellar: :any,                 mojave:         "92c77224cffd95acface4d59aeb65a8e4330059c7c183ca4cd8df7fb90be9ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "645f512ca275ccc7749cb6be5ae149c21c37547ec962961d3fbb835fccb784d0"
  end

  depends_on "cmake" => :build
  depends_on "eigen"

  resource "testdata" do
    url "https://raw.githubusercontent.com/OpenSLAM-org/openslam_g2o/2362b9e1e9dab318625cd0af9ba314c47ba8de48/data/2d/intel/intel.g2o"
    sha256 "4d87aaf96e1e04e47c723c371386b15358c71e98c05dad16b786d585f9fd70ff"
  end

  def install
    cmake_args = std_cmake_args + %w[-DG2O_BUILD_EXAMPLES=OFF]
    # For Intel: manually set desired SSE features to enable support for older machines.
    # See https://gcc.gnu.org/onlinedocs/gcc/x86-Options.html for supported CPU features
    if Hardware::CPU.intel?
      cmake_args << "-DDO_SSE_AUTODETECT=OFF"
      case Hardware.oldest_cpu
      when :nehalem
        cmake_args += %w[-DDISABLE_SSE4_A=ON]
      when :core2
        cmake_args += %w[-DDISABLE_SSE4_1=ON -DDISABLE_SSE4_2=ON -DDISABLE_SSE4_A=ON]
      else
        odie "Unexpected oldest supported CPU \"#{Hardware.oldest_cpu}\""
      end
    end

    system "cmake", "-S", ".", "-B", "build", *cmake_args

    # Avoid references to Homebrew shims
    inreplace "build/g2o/config.h", Superenv.shims_path/ENV.cxx, ENV.cxx

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"examples").install "g2o/examples/simple_optimize"
  end

  test do
    cp_r pkgshare/"examples/simple_optimize", testpath/"src"
    libs = %w[-lg2o_core -lg2o_solver_eigen -lg2o_stuff -lg2o_types_slam2d -lg2o_types_slam3d]
    cd "src" do
      system ENV.cxx, "simple_optimize.cpp",
             "-I#{opt_include}", "-I#{Formula["eigen"].opt_include}/eigen3",
             "-L#{opt_lib}", *libs, "-std=c++11", "-o", testpath/"simple_optimize"
    end

    resource("testdata").stage do
      last_output = shell_output(testpath/"simple_optimize intel.g2o 2>&1").lines.last
      assert_match("edges= 1837", last_output)
    end
  end
end
