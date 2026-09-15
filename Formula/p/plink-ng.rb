class PlinkNg < Formula
  desc "Whole-genome association analysis toolset (PLINK 2.0)"
  homepage "https://www.cog-genomics.org/plink/2.0/"
  url "https://github.com/chrchang/plink-ng/archive/refs/tags/v2.0.0-a.7.6.tar.gz"
  version "2.0.0-a.7.6"
  sha256 "e305761e80441a719f76485acec6e5eb0610e3ad792a58933e535a4ac260d50f"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-a\.\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e331b3c0942c1afd2deb3b4d671c4a4381bcda08439ec71a716d2c9485bc25f8"
    sha256 cellar: :any, arm64_tahoe:       "7c790868d62869479c32b49dbc42b6f72a52dde09637eaea1eaa71d059c332ae"
    sha256 cellar: :any, arm64_sequoia:     "af57f78042269de8258547ff607b99ba38c6f98ad0f5774409556be37e500224"
    sha256 cellar: :any, arm64_linux:       "2d4d9a403422a93cd2307a95473d1ab528e57cd786df9e25a7c9a8c04c51ad2d"
    sha256 cellar: :any, x86_64_linux:      "b394a607fec93b40cc4657da17b970515a5f1030c6bb8085bad21c4bf5392769"
  end

  depends_on "zstd"

  on_linux do
    depends_on "openblas"
    depends_on "zlib-ng-compat"
  end

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

    # --pca goes through the BLAS/LAPACK backend.
    system bin/"plink2", "--pfile", "dummy", "--pca", "2", "--out", "pca"
    assert_equal 2, (testpath/"pca.eigenval").read.lines.count
  end
end
