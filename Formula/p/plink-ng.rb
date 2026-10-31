class PlinkNg < Formula
  desc "Whole-genome association analysis toolset (PLINK 2.0)"
  homepage "https://www.cog-genomics.org/plink/2.0/"
  url "https://github.com/chrchang/plink-ng/archive/refs/tags/v2.0.0-b.1.3.tar.gz"
  version "2.0.0-b.1.3"
  sha256 "e36dde2aad1f4b8980c8454f4b6a744016a1e4298eef8c130ffd433d92eaec23"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-[ab]\.\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b09ca1f3dd0d3c7acf5c85dd505b481fe0a59e6843937290078a1c1e57c08fab"
    sha256 cellar: :any, arm64_tahoe:       "00fd9b5bc978289db53baff0b8c487c2af70f39d7f175cd5d96908e73fbd7dc2"
    sha256 cellar: :any, arm64_sequoia:     "4dbf12bc946d0550b8ea8ecd0d516f6a78cbb5dc07901ae1206f6d051e2ddd78"
    sha256 cellar: :any, arm64_linux:       "ab66ff1c07cd0c738b3936d18b03275c154b3446b81c366926988528325b69dc"
    sha256 cellar: :any, x86_64_linux:      "5f84cbe4a4b66481d6ae788039ca0528601b71aeb8694233f2d770d15f178cea"
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
      args += ["BLASFLAGS=-L#{formula_opt_lib("openblas")}", "BLASLIBS=-lopenblas"] if OS.linux?

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
