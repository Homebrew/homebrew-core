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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fb433428e8386f8c9f8b13024d6836a22572a3c85ae9f37715b6e55e0273dfb5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "96f621af00b7ab122779c032f1b99998fcf7e11a21f91f5f0cd447b42f602330"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "737ef1bbdc78f82560f2be2432dcb4db94b328c96128a727d5bfcfef947fcdc9"
    sha256 cellar: :any,                 arm64_linux:       "0e814194b57cb6f0b44c3094a85a11d305beb34a00d81a8c55ac9870fca27c25"
    sha256 cellar: :any,                 x86_64_linux:      "2b501a06fe30a39a547bfe3222519931dff1932b9743f3daef9891c1083a2e44"
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
