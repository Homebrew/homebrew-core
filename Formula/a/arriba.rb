class Arriba < Formula
  desc "Fast and accurate gene fusion detection from RNA-Seq data"
  homepage "https://github.com/suhrig/arriba"
  url "https://github.com/suhrig/arriba/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "75090d7411fe9e67139c1f7bddbb2082fa2805cacd9b6cb3fa285688a66dd33a"
  license "MIT"
  head "https://github.com/suhrig/arriba.git", branch: "master"

  depends_on "htslib"

  resource "hat-trie" do
    url "https://github.com/Tessil/hat-trie/archive/refs/tags/v0.6.0.tar.gz"
    sha256 "f3793fd46f07bdf3de67d719b602c84f66121d81aa02d9e6d53de03ae3444c80"
  end

  def install
    resource("hat-trie").stage do
      (buildpath/"libraries").install "include/tsl"
    end

    # Upstream's `all` target downloads private copies of the dependencies and
    # there is no `install` target. Build `arriba` against the htslib formula
    # (headers are included unqualified, e.g. `#include "sam.h"`) until the
    # `shared` and `install` targets from https://github.com/suhrig/arriba/pull/287 are released.
    system "make", "arriba",
           "CPPFLAGS=-I#{formula_opt_include("htslib")}/htslib",
           "LDFLAGS=-L#{formula_opt_lib("htslib")} " \
           "-Wl,-rpath,#{rpath(target: formula_opt_lib("htslib"))}",
           "LIBS_SO=-lhts -lm"

    bin.install "arriba"
    # These wrappers drive STAR, samtools and R, which are not dependencies
    # of the binary itself, so keep them out of the PATH.
    pkgshare.install "download_references.sh", "draw_fusions.R", "run_arriba.sh", "scripts"
  end

  test do
    # Deterministic stand-in for a reference genome.
    random_sequence = lambda do |seed, length|
      state = seed
      Array.new(length) do
        state = ((state * 1_103_515_245) + 12_345) % 2_147_483_648
        "ACGT"[(state >> 16) % 4]
      end.join
    end
    contigs = { "chr1" => random_sequence.call(1, 1000), "chr2" => random_sequence.call(2, 1000) }

    (testpath/"assembly.fa").write(contigs.map do |name, sequence|
      ">#{name}\n#{sequence.scan(/.{1,60}/).join("\n")}\n"
    end.join)

    # Two two-exon genes, so that the fusion below lands on real splice sites.
    (testpath/"annotation.gtf").write <<~GTF
      chr1\ttest\texon\t101\t400\t.\t+\t.\tgene_id "G1"; gene_name "GENE1"; transcript_id "T1";
      chr1\ttest\texon\t501\t700\t.\t+\t.\tgene_id "G1"; gene_name "GENE1"; transcript_id "T1";
      chr2\ttest\texon\t101\t300\t.\t+\t.\tgene_id "G2"; gene_name "GENE2"; transcript_id "T2";
      chr2\ttest\texon\t401\t700\t.\t+\t.\tgene_id "G2"; gene_name "GENE2"; transcript_id "T2";
    GTF

    # Split reads spanning a GENE1-GENE2 junction at chr1:400 -> chr2:401.
    # The anchor length varies so the reads are not taken for duplicates.
    sam = ["@HD\tVN:1.6\tSO:coordinate", "@SQ\tSN:chr1\tLN:1000", "@SQ\tSN:chr2\tLN:1000"]
    10.times do |i|
      anchor = 20 + i
      overhang = 80 - anchor
      start = 400 - anchor + 1
      sequence = contigs["chr1"][start - 1, anchor] + contigs["chr2"][400, overhang]
      quality = "I" * (anchor + overhang)
      sam << "s#{i}\t0\tchr1\t#{start}\t60\t#{anchor}M#{overhang}S\t*\t0\t0\t#{sequence}\t#{quality}\t" \
             "SA:Z:chr2,401,+,#{anchor}S#{overhang}M,60,0;"
      sam << "s#{i}\t2048\tchr2\t401\t60\t#{anchor}S#{overhang}M\t*\t0\t0\t#{sequence}\t#{quality}\t" \
             "SA:Z:chr1,#{start},+,#{anchor}M#{overhang}S,60,0;"
    end
    (testpath/"alignments.sam").write "#{sam.join("\n")}\n"

    # The blacklist filter needs the database shipped in the release tarball,
    # and relative_support needs a realistic expression background; neither
    # can be reproduced by a fixture this small.
    system bin/"arriba", "-x", "alignments.sam", "-g", "annotation.gtf", "-a", "assembly.fa",
           "-o", "fusions.tsv", "-f", "blacklist,relative_support"

    fusions = (testpath/"fusions.tsv").read
    assert_match "GENE1\tGENE2", fusions
    assert_match "chr1:400\tchr2:401", fusions
    assert_match "exon/splice-site\texon/splice-site\ttranslocation", fusions

    assert_match "Version: #{version}", shell_output("#{bin}/arriba -h")
  end
end
