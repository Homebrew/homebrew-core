class G2o < Formula
  desc "General framework for graph optimization"
  homepage "https://openslam-org.github.io/g2o.html"
  url "https://github.com/RainerKuemmerle/g2o/archive/refs/tags/20230806_git.tar.gz"
  version "20230806"
  sha256 "e717d3b96cc6d00fcbbaf637aae648c9823599e6aa8fcf4546fc9ad4034dcde5"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)(?:[._-]git)?$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a4cf0e133686f2d44f48b84f43f8cb43992db9f08cc2166520e768e13750fe1c"
    sha256 cellar: :any,                 arm64_sonoma:   "cbb981a42b19ca21f85263240d4d4659886ff14ba366ae4dd5643074b1c23909"
    sha256 cellar: :any,                 arm64_ventura:  "d1cbe8ce20b3b583d8390364a2d76a745cf3cdfd7dbed194fa456b4ea9a251db"
    sha256 cellar: :any,                 arm64_monterey: "8945d0ec8a2a00ce3e5bda9e3bd83953e37d2f5828b0f078b45dab8b35aaeb70"
    sha256 cellar: :any,                 arm64_big_sur:  "77b3b006d9e12ea5176de813963afae700cebecd2c7fbb42ad6dd98d636fb386"
    sha256 cellar: :any,                 sonoma:         "3fb4423a1a091ae6a1d394a1bda3be4c17834a1a0c6b41b47bf004e1616ffc2f"
    sha256 cellar: :any,                 ventura:        "67ba9a8b944f127858cbe66fff742ab900c498f27535e3287feb67161db110cf"
    sha256 cellar: :any,                 monterey:       "eaa5b6858b45b308096959db38d5dcc59e74ac18548a2f183242c1313af4dee7"
    sha256 cellar: :any,                 big_sur:        "3cd190b553f999dde5bf21c7f46bf4d24ad721d4381f366afe42166a41088a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1e1c14c76fcd64f70797ff40f04b9d8861ca44f557f830ea8407e33201a0936"
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
             "-L#{opt_lib}", *libs, "-std=c++17", "-o", testpath/"simple_optimize"
    end

    resource("homebrew-testdata").stage do
      last_output = shell_output(testpath/"simple_optimize intel.g2o 2>&1").lines.last
      assert_match("edges= 1837", last_output)
    end
  end
end
