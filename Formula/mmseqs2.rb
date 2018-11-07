class Mmseqs2 < Formula
  desc "Software suite for very fast protein sequence search and clustering"
  homepage "https://mmseqs.org/"
  url "https://github.com/soedinglab/MMseqs2/archive/6-f5a1c.tar.gz"
  version "6-f5a1c"
  sha256 "41a7b3114a2f54796e0d4e423045ee1bc3372834f75c72956e5c9eda520db586"

  bottle do
    cellar :any
    sha256 "463770152ed8e5e899b7c42b132812c48b759bd3442c3bb255c1bf4f14f6ab53" => :mojave
    sha256 "6e07b5c3e7022c01849a81a6f93099e801298cb3a8ad422b16f607775f3e181f" => :high_sierra
    sha256 "626935c11f55e65feb18b9ae0dd8cd51ce66a990d9dacd4de38625c31506068e" => :sierra
    sha256 "8c59649bdd215283fae0ea307241b359aaf17634fb5c255b88f6fb86432f01c3" => :el_capitan
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
