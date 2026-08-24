class Fastani < Formula
  desc "Fast whole-genome similarity (ANI) estimation"
  homepage "https://github.com/ParBLiSS/FastANI"
  url "https://github.com/ParBLiSS/FastANI/archive/refs/tags/v1.34.tar.gz"
  sha256 "dc185cf29b9fa40cdcc2c83bb48150db46835e49b9b64a3dbff8bc4d0f631cb1"
  license "Apache-2.0"
  head "https://github.com/ParBLiSS/FastANI.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8cc460f3dec2f9607eeb148cb206153f9b70f9ff1781e274c555ae9829c08fe0"
    sha256 cellar: :any, arm64_sequoia: "dcd4709d2759c833baadc72446b5843b3bee5ef16347273450fedc04668687d4"
    sha256 cellar: :any, arm64_sonoma:  "18162b38178b97a1e0e126853ae1e6b48439fe2a66a3944e809a5fe54a1fbff4"
    sha256 cellar: :any, sonoma:        "3ab6a3079128f607bdce90b49333eab896427ac1ba9f28efdd2793466bfcbb1e"
    sha256 cellar: :any, arm64_linux:   "67bd94487290369e72806cc1329343722832c64a08f57e2ddce254fe7935809e"
    sha256 cellar: :any, x86_64_linux:  "dde7bee1eb292480f3698e015f5a9ce24083575ca01471800303e324a0d73aab"
  end

  depends_on "cmake" => :build
  depends_on "gsl"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -DCMAKE_CXX_STANDARD=11
      -DGSL_ROOT_DIR=#{formula_opt_prefix("gsl")}
    ]
    args << "-DOpenMP_CXX_FLAGS:STRING=-Xpreprocessor;-fopenmp;-I#{formula_opt_include("libomp")}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "tests/data", "scripts"
  end

  test do
    system bin/"fastANI",
           "-q", pkgshare/"data/Shigella_flexneri_2a_01.fna",
           "-r", pkgshare/"data/Escherichia_coli_str_K12_MG1655.fna",
           "-o", testpath/"out",
           "--matrix"
    assert_path_exists testpath/"out"
    assert_path_exists testpath/"out.matrix"
  end
end
