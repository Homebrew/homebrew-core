class G2o < Formula
  desc "General framework for graph optimization"
  homepage "https://openslam-org.github.io/g2o.html"
  url "https://github.com/RainerKuemmerle/g2o/archive/refs/tags/20241228_git.tar.gz"
  version "20241228"
  sha256 "d691ead69184ebbb8256c9cd9f4121d1a880b169370efc0554dd31a64802a452"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)(?:[._-]git)?$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5ad0c65eda4765cf3816241e2d0604e2c2853783f6d9e8349843a97524f5fb43"
    sha256 cellar: :any,                 arm64_sequoia: "e153559ae44f9a8f966ce19056422e03d812cca7c17e3787a9998ef2b03d12c5"
    sha256 cellar: :any,                 arm64_sonoma:  "0effe3348f065a1ed358fd4555b51b5c28f02e846c21613452291db66690eea2"
    sha256 cellar: :any,                 tahoe:         "e5b0c09abb8b30d083725953ccbff1f932572fb130a6b32fb406068e8d16bb40"
    sha256 cellar: :any,                 sequoia:       "774980c34fa4a1e3bb4e7872f0fa5669786132ad28ed179d7377426d6bc9ed23"
    sha256 cellar: :any,                 sonoma:        "bc60e66fe653f8541745eb9c767cef2b86b9710ea32d631020bdce5b03c7f8ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0248efaf0de4f324fcab96dcb21faf224f4064249405f85ef7715bd3a2304001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5ba022e961df0b0629d7b57185a7867ede5c71151bf55720f06cee79fe75f61"
  end

  depends_on "cmake" => :build
  depends_on "eigen"

  # Backport support for eigen 5.0.0
  patch do
    url "https://github.com/RainerKuemmerle/g2o/commit/5ad2b3d8b550bad67242d90115f28c5b725da2a1.patch?full_index=1"
    sha256 "f2c0139a045b0ef7380d56d368d1ee0cbd11feeff2dede9858d6a8532a7103bb"
  end
  patch do
    url "https://github.com/RainerKuemmerle/g2o/commit/ef80e643adeb700536dd282dd4316c90cfc05fe8.patch?full_index=1"
    sha256 "ac9abf38a4425fd95ceb4a295160bec5a2f2bbd2bb2f8695951ba9e0c101edc4"
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
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/OpenSLAM-org/openslam_g2o/2362b9e1e9dab318625cd0af9ba314c47ba8de48/data/2d/intel/intel.g2o"
      sha256 "4d87aaf96e1e04e47c723c371386b15358c71e98c05dad16b786d585f9fd70ff"
    end

    cp_r pkgshare/"examples/simple_optimize", testpath/"src"
    libs = %w[-lg2o_core -lg2o_solver_eigen -lg2o_stuff -lg2o_types_slam2d -lg2o_types_slam3d]
    cd "src" do
      system ENV.cxx, "simple_optimize.cpp",
             "-I#{opt_include}", "-I#{Formula["eigen"].opt_include}/eigen3",
             "-L#{opt_lib}", *libs, "-std=c++17", "-o", testpath/"simple_optimize"
    end

    resource("homebrew-testdata").stage do
      last_output = shell_output("#{testpath}/simple_optimize intel.g2o 2>&1").lines.last
      assert_match("edges= 1837", last_output)
    end
  end
end
