class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/11-e1a1c.tar.gz"
  version "11-e1a1c"
  sha256 "ffe1ae300dbe1a0e3d72fc9e947356a4807f07951cb56316f36974d8d5875cbb"
  head "https://github.com/soedinglab/MMseqs2.git"

  bottle do
    cellar :any
    sha256 "96b2cf5f08089363df4cd8814b7528bac06c1dac8c11f4839c5dee453ce97122" => :catalina
    sha256 "813552b3664a81c0ec2e6ef973acc7d1cb5fdacdc02ddaff4787366ef81b7827" => :mojave
    sha256 "e229477bb366685e7725abb8a7ecfef9d74652266aa2761a7bfdc6b2bc20c39c" => :high_sierra
    sha256 "3fdb5ce1ace58238f4011df2f1f437fdc25031012b6a2e1a95c158a12b2acc3d" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  resource "documentation" do
    url "https://github.com/soedinglab/MMseqs2.wiki.git",
        :revision => "c77918c9cebb24075f3c102a73fb1d413017a1a5"
  end

  def install
    args = *std_cmake_args << "-DHAVE_TESTS=0" << "-DHAVE_MPI=0"
    args << "-DVERSION_OVERRIDE=#{version}"
    args << "-DHAVE_SSE4_1=1"

    libomp = Formula["libomp"]
    args << "-DOpenMP_C_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
    args << "-DOpenMP_C_LIB_NAMES=omp"
    args << "-DOpenMP_CXX_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
    args << "-DOpenMP_CXX_LIB_NAMES=omp"
    args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.a"

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
