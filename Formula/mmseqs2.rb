class Mmseqs2 < Formula
  desc "Software suite for very fast protein sequence search and clustering"
  homepage "https://mmseqs.org/"
  url "https://github.com/soedinglab/MMseqs2/archive/9-d36de.tar.gz"
  version "9-d36de"
  sha256 "2890a748b38ed1a04d98c2197b11bac6b50c1329313b6218ba2f53aeb6c5e874"

  bottle do
    cellar :any
    sha256 "681f2f8d6ff749a72eff0f8d05a8bcf840941c8146ef26e976e78de65564a440" => :mojave
    sha256 "61c186285e1aeef7720fd770f870a452d1ec74fb8fefbf64ec043181fee0aa98" => :high_sierra
    sha256 "71909089e3daab335064614f58e8d2882132fa9c45e99a5e64fbbe250d40b267" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc"

  cxxstdlib_check :skip

  fails_with :clang # needs OpenMP support

  resource "documentation" do
    url "https://github.com/soedinglab/MMseqs2.wiki.git",
        :revision => "00ba0be0690f5b883697bd1dbcb9e0f4b3c18bca"
  end

  def install
    args = *std_cmake_args << "-DHAVE_TESTS=0" << "-DHAVE_MPI=0"
    args << "-DVERSION_OVERRIDE=#{version}"
    args << "-DHAVE_SSE4_1=1"

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
