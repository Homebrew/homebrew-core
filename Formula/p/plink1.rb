class Plink1 < Formula
  desc "Whole-genome association analysis toolset"
  homepage "https://www.cog-genomics.org/plink/1.9/"
  url "https://github.com/chrchang/plink-ng/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "c1da6fc12829108743affc94866391d96021d3c55ed52735e110b89654af85b3"
  license "GPL-3.0-or-later"
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "011c20a42ba25975af270bf7c29d6df52e74370dabc4bf3627819d0a3cffeafb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "94a51199d23efa0ab5cd0e839f54c68df95a2aabb0153bedabe627bd9f9a2965"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c02013e508033a06cb15e6065c8a357653f74b3a25fc791c6a56850780a065a5"
    sha256 cellar: :any,                 arm64_linux:       "238aaa239bf2eff6f3f9478fdfe1ccf8cdcabb602b6b1b4bfc830a64af89f2c0"
    sha256 cellar: :any,                 x86_64_linux:      "7b99efde445ba5e65fcd60da9931e58bd456c2f116f20c0c652fc805e2c7c70a"
  end

  on_linux do
    depends_on "openblas"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "putty", because: "both install a `plink` binary"

  deny_network_access!

  def install
    # PLINK 1.9 lives in the `1.9` subdirectory of the plink-ng repository.
    cd stable.version.major_minor.to_s do
      # Link against the system zlib rather than a vendored copy that is not
      # shipped in the release tarball.
      args = ["ZLIB=-lz"]
      # OpenBLAS ships LAPACK, so a single -lopenblas replaces the ATLAS default.
      args << "BLASFLAGS=-L#{formula_opt_lib("openblas")} -lopenblas" if OS.linux?

      system "make", *args
      bin.install "plink"
    end
  end

  test do
    # Simulate a small cohort, then check the generated genotype file is usable.
    system bin/"plink", "--dummy", "50", "100", "--out", "dummy"
    assert_path_exists testpath/"dummy.bed"

    system bin/"plink", "--bfile", "dummy", "--freq", "--out", "freq"
    freqs = (testpath/"freq.frq").read
    assert_match "MAF", freqs
    assert_equal 101, freqs.lines.count

    # --pca goes through the BLAS/LAPACK backend.
    system bin/"plink", "--bfile", "dummy", "--pca", "2", "--out", "pca"
    assert_equal 2, (testpath/"pca.eigenval").read.lines.count
  end
end
