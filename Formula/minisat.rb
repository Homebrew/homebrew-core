class Minisat < Formula
  desc "Boolean satisfiability (SAT) problem solver"
  homepage "http://minisat.se"
  url "https://github.com/niklasso/minisat/archive/releases/2.2.0.tar.gz"
  sha256 "3ed44da999744c0a1be269df23c3ed8731cdb83c44a4f3aa29b3d6859bb2a4da"
  revision 2

  bottle do
    sha256 "391a3fa8d268b34fe03a50a2cce15794dac827cd23f1ac86a8a45c88c87fb570" => :mojave
    sha256 "20256b35c118c4b338cd8eb74fc81838dc3da50c2f3464238ad1c9b042574b03" => :high_sierra
    sha256 "902e87ede339024a790a70fdfad1d4c6d0a7c18f10b0392cc0b4b32bceedca7f" => :sierra
    sha256 "8fd1e0f6dfaae107599581e674f1ed229436187d3a85a9290e5ff1c16cc21047" => :el_capitan
  end

  depends_on "gcc"

  fails_with :clang do
    cause "error: friend declaration specifying a default argument must be a definition"
  end

  # Upstream commits to fix some declaration errors
  patch do
    url "https://github.com/niklasso/minisat/commit/9bd874980a7e5d65cecaba4edeb7127a41050ed1.patch?full_index=1"
    sha256 "80be41fb79648ce41f9822115a8af1f0d356304c44d810e1fb5ed18b39bd1cfb"
  end

  patch do
    url "https://github.com/niklasso/minisat/commit/cfae87323839064832c8b3608bf595548dd1a1f3.patch?full_index=1"
    sha256 "72c4d0f2ba7ae3561eac04418d1757fc5bf185c5b29dcaa775b8e9efab3796bc"
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
