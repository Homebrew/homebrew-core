class Mmseqs2 < Formula
  desc "Software suite for very fast protein sequence search and clustering"
  homepage "https://mmseqs.org/"
  url "https://github.com/soedinglab/MMseqs2/archive/1-c7a89.tar.gz"
  version "1-c7a89"
  sha256 "e756a0e5cb3aa8e1e5a5b834a58ae955d9594be1806f0f32800427c55f3a45d5"

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
        :revision => "6dbd3666edb64fc71173ee714014e88c1ebe2dfc"
  end

  def install
    # version information is read from git by default
    # next MMseqs2 version will include a cmake flag so we do not need this hack
    inreplace "src/version/Version.cpp", /.+/m, "const char *version = \"#{version}\";"

    args = *std_cmake_args << "-DHAVE_TESTS=0" << "-DHAVE_MPI=0"

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
    system "#{bin}/mmseqs", "cluster", "q", "res", "tmp", "-s", "1", "--cascaded"
  end
end
