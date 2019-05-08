class Mmseqs2 < Formula
  desc "Software suite for very fast protein sequence search and clustering"
  homepage "https://mmseqs.org/"
  url "https://github.com/soedinglab/MMseqs2/archive/8-fac81.tar.gz"
  version "8-fac81"
  sha256 "035d1c9a5fcfae50bc2d201f177722bd79d95d3ba32342972baa7b142b52aa82"
  revision 1

  bottle do
    cellar :any
    sha256 "1453917340436e36566e7404ec973475740d79f06e71cc2b97830cf017b2aaa8" => :mojave
    sha256 "b2a997519dedb4538e31b3ef91efd946a2c0414d71ebef18f529d0f918b7546a" => :high_sierra
    sha256 "578ea72406c8522e5acd29c3d3e596ed653b4a1c26f2accfd78444a0e2848c4f" => :sierra
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
