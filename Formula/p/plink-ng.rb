class PlinkNg < Formula
  desc "Whole-genome association analysis toolset (PLINK 2.0)"
  homepage "https://www.cog-genomics.org/plink/2.0/"
  url "https://github.com/chrchang/plink-ng/archive/refs/tags/v2.0.0-a.7.8.tar.gz"
  version "2.0.0-a.7.8"
  sha256 "58a8a9ecd7a64b4354f673c04d551adb53411968142d5e5acea2951b530aa4a7"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-a\.\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1b5bfa9f20fee7734dc6cbc4ea893f1fa0beef81c27f5fbcc099ef4b3a0543d3"
    sha256 cellar: :any, arm64_tahoe:       "5beb529aa938b017068f4a428402f18f7dac13cd52d77ff9f5c865c0b707abe5"
    sha256 cellar: :any, arm64_sequoia:     "423f8e0ece2f993373dfc2d4ab8cbb5657e7457060b3daba17d14e3949aa6c37"
    sha256 cellar: :any, arm64_linux:       "47257f6018f0fc203ba29e6541c4878eccd57bb57524400ce7b2d3471c74a2de"
    sha256 cellar: :any, x86_64_linux:      "ec3113f241a5fb4d12d0c6ac568319d64683712d45a5e669d0241e555d7b5faf"
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

    # --pca goes through the BLAS/LAPACK backend.
    system bin/"plink2", "--pfile", "dummy", "--pca", "2", "--out", "pca"
    assert_equal 2, (testpath/"pca.eigenval").read.lines.count
  end
end
