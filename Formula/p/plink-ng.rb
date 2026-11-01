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
    sha256 cellar: :any, arm64_golden_gate: "82d09cd707d2aa8ba5158304e825c23e44960cd34ac7660c34060fb90757cd75"
    sha256 cellar: :any, arm64_tahoe:       "062fd1ff0b22c801be9456e122247662f1fc8607075c9f8a8f5256e34f2ba04c"
    sha256 cellar: :any, arm64_sequoia:     "7afb02db80c7e32177007afa050b4f8274d8f5476b2430bf725f28c0d8170a3c"
    sha256 cellar: :any, arm64_linux:       "44321610b1c2b021d1a5e55934483bcdd3a52b6f5cc6d31157501ad18e7b15ff"
    sha256 cellar: :any, x86_64_linux:      "6eb2ad87cd364fac8de95229e406779bd2549fee53602190eb310b6e5859aaea"
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
