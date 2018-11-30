class Mmseqs2 < Formula
  desc "Software suite for very fast protein sequence search and clustering"
  homepage "https://mmseqs.org/"
  url "https://github.com/soedinglab/MMseqs2/archive/7-4e23d.tar.gz"
  version "7-4e23d"
  sha256 "39b04ea60741ca209c37be129b852b5024fed1691817e6eb1e80e382f7261724"

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
        :revision => "d3607c7913e67c7bb553a8dff0cc66eeb3387506"
  end

  def install
    args = *std_cmake_args << "-DHAVE_TESTS=0" << "-DHAVE_MPI=0"
    args << "-DVERSION_OVERRIDE=#{version}"

    args << "-DHAVE_SSE4_1=1" if build.bottle?

    system "cmake", ".", *args
    system "make", "install"

    resource("documentation").stage { doc.install Dir["*"] }
    pkgshare.install "examples"
    bash_completion.install "util/bash-completion.sh" => "mmseqs.sh"
  end

  def caveats
    unless Hardware::CPU.sse4?
      "MMseqs2 requires at least SSE4.1 CPU instruction support. The binary will not work correctly."
    end
  end

  test do
    system "#{bin}/mmseqs", "createdb", "#{pkgshare}/examples/QUERY.fasta", "q"
    system "#{bin}/mmseqs", "cluster", "q", "res", "tmp", "-s", "1"
    assert_predicate testpath/"res", :exist?
    assert_predicate (testpath/"res").size, :positive?
    assert_predicate testpath/"res.index", :exist?
    assert_predicate (testpath/"res.index").size, :positive?
  end
end
