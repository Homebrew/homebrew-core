class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/12-113e3.tar.gz"
  version "12-113e3"
  sha256 "81fa0d77eab9d74b429567da00aa7ec2d46049537ce469595d7356b6d8b5458a"
  license "GPL-3.0-or-later"
  head "https://github.com/soedinglab/MMseqs2.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "19e991c528466e6443a0772d6ea2c373b5323f3b6d919adde3ec2cd6958c6e04" => :catalina
    sha256 "f31e32a418bb6a407be63e5d60c4bcc10497c3412b07fe270ac523851fbeeea7" => :mojave
    sha256 "6a92a84f48542cac881e7bf4de5c7946d8038e8da1c799c98fe0992ed3f4d1a0" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "wget"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  resource "documentation" do
    url "https://github.com/soedinglab/MMseqs2.wiki.git",
        revision: "d53d8be3761ee625b0dcddda29b092bbd02244ef"
  end

  def install
    args = *std_cmake_args << "-DHAVE_TESTS=0" << "-DHAVE_MPI=0"
    args << "-DVERSION_OVERRIDE=#{version}"
    args << "-DHAVE_SSE4_1=1"

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
    "MMseqs2 requires at least SSE4.1 CPU instruction support." unless Hardware::CPU.sse4?
  end

  test do
    system "#{bin}/mmseqs", "createdb", "#{pkgshare}/examples/QUERY.fasta", "q"
    system "#{bin}/mmseqs", "cluster", "q", "res", "tmp", "-s", "1"
    system "#{bin}/mmseqs", "createtsv", "q", "q", "res", "res.tsv"
    assert_predicate testpath/"res.tsv", :exist?
    assert_predicate (testpath/"res.tsv").size, :positive?
  end
end
