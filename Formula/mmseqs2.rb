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
    sha256 "9bc41128722a0a926cc30fca2cfb29574bb150deb8acc482cd61e7e49e8169fb" => :catalina
    sha256 "789fa0f2f9bef66df73de586236dbffb037f8a32794e47768818d1fc732c05e2" => :mojave
    sha256 "d3f8b1a3ba35b0af1e80a0a917d915e8c19ea542bde20879c3031f1138af55aa" => :high_sierra
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
