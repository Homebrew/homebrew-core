class G2o < Formula
  desc "General framework for graph optimization"
  homepage "https://openslam-org.github.io/g2o.html"
  url "https://github.com/RainerKuemmerle/g2o/archive/refs/tags/20230223_git.tar.gz"
  version "20230223"
  sha256 "c8cf002f636ce2e83fc96f5e8257be4020cf1ae9f6a9d71838ec024f4d8a16cf"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)(?:[._-]git)?$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a3b6d5e633a19b498d0021e192bd1accf972fdedd837c86037bc8d285d3fa412"
    sha256 cellar: :any,                 arm64_monterey: "c5c08f0adc21112a2402cab26e24672a6fc340971e49be81b616a2019f7bd833"
    sha256 cellar: :any,                 arm64_big_sur:  "2b2f4166f6b22d7044f50b2febca70a173567bdbbc27655cea3f3228af3931f9"
    sha256 cellar: :any,                 ventura:        "bb1f0c62c4f0f1d4cfcb8e2e353e9788ee7857086c8c345ac5fab02f7fb72960"
    sha256 cellar: :any,                 monterey:       "31bd808038407640465775c5770417cada686d17811ab8fb045b99570d34294d"
    sha256 cellar: :any,                 big_sur:        "9e2f48ed3049183ce84e30ae541f3eceb2b41dcd4b47a426bff14c7aa1a4be50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dc0e4a51f41c1575782966a1b0229347173e69860c879405390abf0e24cbc10"
  end

  depends_on "cmake" => :build
  depends_on "eigen"

  resource "homebrew-testdata" do
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

    resource("homebrew-testdata").stage do
      last_output = shell_output(testpath/"simple_optimize intel.g2o 2>&1").lines.last
      assert_match("edges= 1837", last_output)
    end
  end
end
