class Goleft < Formula
  desc "Tools for coverage and QC of BAM/CRAM files, including indexcov"
  homepage "https://github.com/brentp/goleft"
  url "https://github.com/brentp/goleft/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "0c563edea898059a75adf6250149643bdc61e4660544fabafbaefc09b4c9d1b3"
  license "MIT"
  head "https://github.com/brentp/goleft.git", branch: "master"

  depends_on "go" => :build
  # `goleft depth` and `goleft multidepth` run `samtools` from PATH.
  depends_on "samtools"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./cmd/goleft"
  end

  test do
    sam = [
      "@HD\tVN:1.6\tSO:coordinate",
      "@SQ\tSN:chr1\tLN:1000",
      "@RG\tID:rg1\tSM:sampleA",
      "r1\t0\tchr1\t10\t60\t10M\t*\t0\t0\tACGTACGTAC\tIIIIIIIIII\tRG:Z:rg1",
      "r2\t0\tchr1\t20\t60\t10M\t*\t0\t0\tACGTACGTAC\tIIIIIIIIII\tRG:Z:rg1",
      "r3\t0\tchr1\t25\t60\t10M\t*\t0\t0\tACGTACGTAC\tIIIIIIIIII\tRG:Z:rg1",
    ].join("\n")
    (testpath/"reads.sam").write "#{sam}\n"

    samtools = formula_opt_bin("samtools")/"samtools"
    system samtools, "sort", "-o", "reads.bam", "reads.sam"
    system samtools, "index", "reads.bam"

    (testpath/"ref.fa").write ">chr1\n#{"ACGT" * 250}\n"
    system samtools, "faidx", "ref.fa"

    assert_equal "sampleA", shell_output("#{bin}/goleft samplename reads.bam").strip

    system bin/"goleft", "depth", "--windowsize", "100", "--reference", "ref.fa", "--prefix", "out", "reads.bam"
    assert_match "chr1\t0\t100\t0.3\n", (testpath/"out.depth.bed").read

    assert_match "goleft Version: #{version}", shell_output("#{bin}/goleft 2>&1", 1)
  end
end
