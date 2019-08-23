class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/10-6d92c.tar.gz"
  version "10-6d92c"
  sha256 "62415e545706adc6e9e6689d34902f405ab5e5c67c8c7562bdd9dd4da2088697"

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
        :revision => "03da86a5c553d00c8d4484e9fbd8d68ef14e1169"
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
