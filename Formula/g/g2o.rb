class G2o < Formula
  desc "General framework for graph optimization"
  homepage "https://openslam-org.github.io/g2o.html"
  url "https://github.com/RainerKuemmerle/g2o/archive/refs/tags/20241228_git.tar.gz"
  version "20241228"
  sha256 "d691ead69184ebbb8256c9cd9f4121d1a880b169370efc0554dd31a64802a452"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)(?:[._-]git)?$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "14a9b3fa5a5807affa0289809e379b64edf01d701f3b5a654f2ca42b8325c41a"
    sha256 cellar: :any,                 arm64_sonoma:  "9cad139379e98c63deaf37bed5ad74793ccb2730804f498e647faf996e8cc418"
    sha256 cellar: :any,                 arm64_ventura: "ee55fcb396513cf2bdd28f279f6616c2e47cb5d86d19a7b2a4b5a0b30323952f"
    sha256 cellar: :any,                 sonoma:        "b5dd18e068c2dd0e29b798854806ed1a441beca2b6d1c9b763b9891c7b6e4514"
    sha256 cellar: :any,                 ventura:       "70d60d6efa8c3216129d34777c0715f7cfa5fa0c3a23f86335b0609ffb989dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "432f0cc70da40868d5e102a30d2d4d0ce26c70b2431e5fa5fc4922de981b7046"
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
      when :nehalem, :westmere
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
