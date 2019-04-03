class Mmseqs2 < Formula
  desc "Software suite for very fast protein sequence search and clustering"
  homepage "https://mmseqs.org/"
  url "https://github.com/soedinglab/MMseqs2/archive/8-fac81.tar.gz"
  version "8-fac81"
  sha256 "035d1c9a5fcfae50bc2d201f177722bd79d95d3ba32342972baa7b142b52aa82"

  bottle do
    cellar :any
    sha256 "e90c697974e8bfac9ab2cba1c25521de6d8967f42c4191f5f53fb97809fce4e3" => :mojave
    sha256 "3d65ac201907466812a84eba4e5cbd65e9921844b20d611b89ee4dadcd748529" => :high_sierra
    sha256 "e27970a0d1e68e4385dd0aa29a0d91a62d297b4879a12ea5a512ac2356b333a7" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc"

  cxxstdlib_check :skip

  fails_with :clang # needs OpenMP support

  resource "documentation" do
    url "https://github.com/soedinglab/MMseqs2.wiki.git",
        :revision => "a4f660d1bbf5e71438d03e09fa4ca036ceb18128"
  end

  def install
    args = *std_cmake_args << "-DHAVE_TESTS=0" << "-DHAVE_MPI=0"
    args << "-DVERSION_OVERRIDE=#{version}"
    args << "-DHAVE_SSE4_1=1"

    # Workaround for issue introduced in macOS 10.14 SDK
    # SDK uses _Atomic in ucred.h which current g++ does not support
    # __APPLE_API_STRICT_CONFORMANCE makes sysctl.h not include apis like ucred.h
    # and thus we dont fail compilation anymore
    # See: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=89864
    args << "-DCMAKE_CXX_FLAGS=-D__APPLE_API_STRICT_CONFORMANCE"

    system "cmake", ".", *args
    system "make", "install"

    resource("documentation").stage { doc.install Dir["*"] }
    pkgshare.install "examples"
    bash_completion.install "util/bash-completion.sh" => "mmseqs.sh"
  end

  def caveats
    unless Hardware::CPU.sse4?
      "MMseqs2 requires at least SSE4.1 CPU instruction support."
    end
  end

  test do
    system "#{bin}/mmseqs", "createdb", "#{pkgshare}/examples/QUERY.fasta", "q"
    system "#{bin}/mmseqs", "cluster", "q", "res", "tmp", "-s", "1"
    system "#{bin}/mmseqs", "createtsv", "q", "q", "res", "res.tsv"
    assert_predicate testpath/"res.tsv", :exist?
    assert_predicate (testpath/"res.tsv").size, :positive?
  end
end
