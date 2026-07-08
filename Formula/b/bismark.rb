class Bismark < Formula
  desc "Bisulfite read mapper and methylation caller"
  homepage "https://github.com/FelixKrueger/Bismark"
  url "https://github.com/FelixKrueger/Bismark/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "b7e69f8e4893059f73863a8d2835245e70132715fdf49163b453bb7c0a8de61d"
  license "GPL-3.0-or-later"

  depends_on "bowtie2"
  depends_on "minimap2"
  depends_on "samtools"

  uses_from_macos "perl"

  def install
    # Scripts locate sibling tools and templates via FindBin's $RealBin (which
    # resolves symlinks), so install everything into libexec and symlink the
    # user-facing executables. The plotly/ directory holds report templates.
    scripts = %w[
      bismark bismark_genome_preparation bismark_methylation_extractor
      deduplicate_bismark bismark2bedGraph coverage2cytosine bismark2report
      bismark2summary bam2nuc filter_non_conversion NOMe_filtering
      methylation_consistency
    ]
    libexec.install scripts, "plotly"
    scripts.each { |s| bin.install_symlink libexec/s }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bismark --version")

    seq = "GAGCTCAAGCTTGGATCCGTCGACCTGCAGGCATGCAAGCTTGAGTATTCTATAGTGTCAC" * 10
    (testpath/"genome/genome.fa").write ">chr1\n#{seq}\n"
    system bin/"bismark_genome_preparation", testpath/"genome"

    (testpath/"reads.fastq").write <<~EOS
      @r1
      GAGTTTAAGTTTGGATTTGTCGATTTGTAGGTATGTAAGTTTGAGTATTTTATAGTGTTAT
      +
      IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
    EOS
    system bin/"bismark", "--genome", testpath/"genome", testpath/"reads.fastq", "-o", testpath
    assert_path_exists testpath/"reads_bismark_bt2.bam"
  end
end
