class Minisat < Formula
  desc "Boolean satisfiability (SAT) problem solver"
  homepage "http://minisat.se"
  url "https://github.com/niklasso/minisat/archive/releases/2.2.0.tar.gz"
  sha256 "3ed44da999744c0a1be269df23c3ed8731cdb83c44a4f3aa29b3d6859bb2a4da"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "38bf5958fc84c017176cfaa13bee246f7a36efc5e992f26728cce654d13fa99c" => :high_sierra
    sha256 "49beae2955b65f28958cca6bbc62d2b167b60ff12c1aa6b11b271f4a930dc147" => :sierra
    sha256 "4b77aa17b8b641964712013ffd0468e35c35a24f04ab285928d40b297abab50d" => :el_capitan
    sha256 "a59c127edb56b612832b7dce88ff7bb426b42d573130a4d201d3f1c619e47006" => :yosemite
  end

  depends_on "gcc"

  # Upstream commits to fix some declaration errors
  patch do
    url "https://github.com/niklasso/minisat/commit/9bd874980a7e5d65cecaba4edeb7127a41050ed1.patch?full_index=1"
    sha256 "80be41fb79648ce41f9822115a8af1f0d356304c44d810e1fb5ed18b39bd1cfb"
  end

  patch do
    url "https://github.com/niklasso/minisat/commit/cfae87323839064832c8b3608bf595548dd1a1f3.patch?full_index=1"
    sha256 "72c4d0f2ba7ae3561eac04418d1757fc5bf185c5b29dcaa775b8e9efab3796bc"
  end

  fails_with :clang do
    cause "error: friend declaration specifying a default argument must be a definition"
  end

  def install
    ENV["MROOT"] = buildpath
    system "make", "-C", "simp", "r"
    bin.install "simp/minisat_release" => "minisat"
  end

  test do
    dimacs = <<~EOS
      p cnf 3 2
      1 -3 0
      2 3 -1 0
    EOS

    assert_match(/^SATISFIABLE$/, pipe_output("#{bin}/minisat", dimacs, 10))
  end
end
