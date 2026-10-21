class PlinkNg < Formula
  desc "Whole-genome association analysis toolset (PLINK 2.0)"
  homepage "https://www.cog-genomics.org/plink/2.0/"
  url "https://github.com/chrchang/plink-ng/archive/refs/tags/v2.0.0-b.1.0.tar.gz"
  version "2.0.0-b.1.0"
  sha256 "07e08fe3a2c3287d5b85697fea95cb7885fbf0d877f792817237c3bf1343411f"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-[ab]\.\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6b36e10047823c5a7878fd16226c18b1df9284aae17c7860b6b85328a0201c9e"
    sha256 cellar: :any, arm64_tahoe:       "17b23b41fb6d08ef711ded4cf95a2188daddc2b7b0d770c5f15d898fca56a1b4"
    sha256 cellar: :any, arm64_sequoia:     "26b57bc80cfc13cf302924b7344a9544de66231eb6358d378fc676e5bff62e0d"
    sha256 cellar: :any, arm64_linux:       "67d4c9fdc5c008a7b660ee69ec174b9b7ff4aa0c6300b92dc2022ed2cc268727"
    sha256 cellar: :any, x86_64_linux:      "67d7578574a3d202ed0f89782e0a6d91def91bc8906f9f8aeffb8b0e1669446a"
  end

  depends_on "zstd"

  on_linux do
    depends_on "openblas"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    cd "2.0/build_dynamic" do
      # Link against zstd rather than the bundled copy.
      args = ["STATIC_ZSTD="]
      # OpenBLAS ships LAPACK and LAPACKE, so a single -lopenblas is enough.
      args << "BLASFLAGS=-L#{formula_opt_lib("openblas")} -lopenblas" if OS.linux?

      system "make", *args
      bin.install "plink2", "pgen_compress"
    end
  end

  test do
    # Simulate a small cohort, then check the generated genotype file is usable.
    system bin/"plink2", "--dummy", "50", "100", "--out", "dummy"
    assert_path_exists testpath/"dummy.pgen"

    system bin/"plink2", "--pfile", "dummy", "--freq", "--out", "freq"
    freqs = (testpath/"freq.afreq").read
    assert_match "ALT_FREQS", freqs
    assert_equal 101, freqs.lines.count

    system bin/"plink2", "--pfile", "dummy", "--make-bed", "--out", "binary"
    assert_path_exists testpath/"binary.bed"

    # --pca goes through the BLAS/LAPACK backend; it needs rare variants filtered.
    system bin/"plink2", "--pfile", "dummy", "--maf", "0.05", "--pca", "2", "--out", "pca"
    assert_equal 2, (testpath/"pca.eigenval").read.lines.count
  end
end
