class Mmseqs2 < Formula
  desc "Software suite for very fast protein sequence search and clustering"
  homepage "https://mmseqs.org/"
  url "https://github.com/soedinglab/MMseqs2/archive/2-23394.tar.gz"
  version "2-23394"
  sha256 "36763fff4c4de1ab6cfc37508a2ee9bd2f4b840e0c9415bd1214280f67b67072"

  bottle do
    cellar :any
    sha256 "f1e551d41c5508ddb96b2b603d2b7df320e8d304a927d5591bc7ecd02211fd58" => :high_sierra
    sha256 "d324056b3fd47e0aa73ba4d8293b2a7248b4dcbe8daf0ff906201019d4c2efb7" => :sierra
    sha256 "c338bc8cc6c622a5c3cbf95a6df6e472b45a92f2bca267b841f747b4ba45abcf" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gcc"

  cxxstdlib_check :skip

  fails_with :clang # needs OpenMP support

  resource "documentation" do
    url "https://github.com/soedinglab/MMseqs2.wiki.git",
        :revision => "fda4cf3f63e4c5b01be9d6b66f6666e81cc8ca99"
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
