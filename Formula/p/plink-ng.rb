class PlinkNg < Formula
  desc "Whole-genome association analysis toolset (PLINK 2.0)"
  homepage "https://www.cog-genomics.org/plink/2.0/"
  url "https://github.com/chrchang/plink-ng/archive/refs/tags/v2.0.0-b.1.4.tar.gz"
  version "2.0.0-b.1.4"
  sha256 "eeae238d4288b9c21ce221f13402d38a3210478f8d8a6c4af0e161c170956d55"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-[ab]\.\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f6359412571e9277befad0099da7833928de45bba814f9d72fde197f843eae4e"
    sha256 cellar: :any, arm64_tahoe:       "36daed01944c32b0b1f3f4c2b31dbd03d0c5a54e7c09de642f3e21fa36db7552"
    sha256 cellar: :any, arm64_sequoia:     "921ba8f5dbafc140a16fbfbb765522fcadd6d72b324dfd035dd8e4e8a4f82682"
    sha256 cellar: :any, arm64_linux:       "4c82ab7c200114f1ae1f20a6a30f7267648664b6e59b2ee15d860920fbecfe73"
    sha256 cellar: :any, x86_64_linux:      "edd302db68e3cf93516ba7c04480ef8070a9464cf30406ebd8224415764deb11"
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
