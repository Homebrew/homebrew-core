class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/12-113e3.tar.gz"
  version "12-113e3"
  sha256 "81fa0d77eab9d74b429567da00aa7ec2d46049537ce469595d7356b6d8b5458a"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/soedinglab/MMseqs2.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "791977eec2f261f8b895d84baab2d8bbd4721c487515257ce1e9b929fa2eb52e" => :big_sur
    sha256 "bd1efb5b4246c6e2ae92f44430885d73feb1e97d8d0fb6971fb3e27fc5868056" => :arm64_big_sur
    sha256 "19e991c528466e6443a0772d6ea2c373b5323f3b6d919adde3ec2cd6958c6e04" => :catalina
    sha256 "f31e32a418bb6a407be63e5d60c4bcc10497c3412b07fe270ac523851fbeeea7" => :mojave
    sha256 "6a92a84f48542cac881e7bf4de5c7946d8038e8da1c799c98fe0992ed3f4d1a0" => :high_sierra
  end

  depends_on "cmake" => [:build, :test]
  depends_on "libomp"
  depends_on "wget"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  resource "documentation" do
    url "https://github.com/soedinglab/MMseqs2.wiki.git",
        revision: "d53d8be3761ee625b0dcddda29b092bbd02244ef"
  end

  resource "testdata" do
    url "https://github.com/soedinglab/MMseqs2/releases/download/12-113e3/MMseqs2-Regression-Minimal.zip"
    sha256 "ab0c2953d1c27736c22a57a1ccbb976c1320435fad82b5c579dbd716b7bae4ce"
  end

  def install
    args = *std_cmake_args << "-DHAVE_TESTS=0" << "-DHAVE_MPI=0"
    args << "-DVERSION_OVERRIDE=#{version}"
    args << if Hardware::CPU.arm?
      "-DHAVE_ARM8=1"
    else
      "-DHAVE_SSE4_1=1"
    end

    libomp = Formula["libomp"]
    args << "-DOpenMP_C_FLAGS=-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include}"
    args << "-DOpenMP_C_LIB_NAMES=omp"
    args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include}"
    args << "-DOpenMP_CXX_LIB_NAMES=omp"
    args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.a"

    # Fix SIMDe on AppleClang11, fixed upstream, remove in next release
    args << "-DCMAKE_CXX_FLAGS=-DSIMDE_NO_CHECK_IMMEDIATE_CONSTANT=1" if DevelopmentTools.clang_build_version == 1100

    system "cmake", ".", *args
    system "make", "install"

    resource("documentation").stage { doc.install Dir["*"] }
    pkgshare.install "examples"
    bash_completion.install "util/bash-completion.sh" => "mmseqs.sh"
  end

  def caveats
    "MMseqs2 requires at least SSE4.1 CPU instruction support." unless Hardware::CPU.sse4? || Hardware::CPU.arm?
  end

  test do
    resource("testdata").stage do
      system "./run_regression.sh", "#{bin}/mmseqs", "scratch"
    end
  end
end
