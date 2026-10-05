class Annotsv < Formula
  desc "Annotation and ranking of structural variations"
  homepage "https://lbgi.fr/AnnotSV/"
  url "https://github.com/lgmgeo/AnnotSV/archive/refs/tags/v3.5.10.tar.gz"
  sha256 "3cf870cf5a5f3b495b4f23eed8fee1e06ab9a6575b1324a20244db62c1e4a015"
  license "GPL-3.0-or-later"
  head "https://github.com/lgmgeo/AnnotSV.git", branch: "master"

  depends_on "bcftools"
  depends_on "bedtools"
  depends_on "tcl-tk"

  def install
    # AnnotSV resolves its installation root from the launcher location, so keep
    # upstream's directory layout under libexec. The default `install` target
    # also clones and pip installs variantconvert and downloads an Exomiser jar,
    # so run only the targets that install AnnotSV itself.
    # AnnotSV looks for share/tcl<version>/AnnotSV first and falls back to the
    # unversioned directory, which keeps it working across tcl-tk upgrades.
    # Upstream's install targets have no ordering prerequisites between them.
    ENV.deparallelize
    system "make", "PREFIX=#{libexec}", "TCL_VERSION=tcl",
           "install-configfile", "install-executable", "install-tcl-toolbox",
           "install-bash-toolbox", "install-doc", "install-others-doc"

    inreplace libexec/"bin/AnnotSV", "#!/usr/bin/env tclsh",
              "#!#{formula_opt_bin("tcl-tk")}/tclsh"

    (bin/"AnnotSV").write_env_script libexec/"bin/AnnotSV",
                                     PATH: "#{formula_opt_bin("bedtools")}:#{formula_opt_bin("bcftools")}:$PATH"

    doc.install "changeLog.txt"
  end

  def caveats
    <<~EOS
      The annotation data sources are not bundled. Download them from
        https://github.com/lgmgeo/AnnotSV#readme
      and pass the directory with `AnnotSV -annotationsDir <path>`.
    EOS
  end

  test do
    genes = testpath/"annotations/Annotations_Human/Genes/GRCh38"
    genebased = testpath/"annotations/Annotations_Human/Gene-based/NCBIandHGNCgeneID"
    benign = testpath/"annotations/Annotations_Human/SVincludedInFt/BenignSV/GRCh38"
    pathogenic = testpath/"annotations/Annotations_Human/FtIncludedInSV/PathogenicSV/GRCh38"
    [genes, genebased, benign, pathogenic].each(&:mkpath)

    gene = "1\t150000\t160000\t+\tTESTGENE\tNM_000546\t151000\t159000\t150000,158000,\t152000,160000,\n"
    (genes/"genes.RefSeq.sorted.bed").write gene
    (genes/"genes.ENSEMBL.sorted.bed").write gene
    (genes/"transcript_version.RefSeq.tsv").write "NM_000546\t6\n"
    (genes/"transcript_version.ENSEMBL.tsv").write "NM_000546\t6\n"
    (genebased/"geneSymbol_NCBIandHGNCgeneID.tsv").write \
      "genes\tNCBI_gene_ID\tHGNC_gene_ID\nTESTGENE\t7157\tHGNC:11998\n"
    %w[Loss Gain Ins Inv].each do |svtype|
      (benign/"benign_#{svtype}_SV_GRCh38.sorted.bed").write "1\t140000\t170000\tbenign\t0.5\n"
      (pathogenic/"pathogenic_#{svtype}_SV_GRCh38.sorted.bed").write "1\t150500\t151500\tpathogenic\tTESTGENE\n"
    end

    (testpath/"input.bed").write "1\t100000\t200000\tDEL\n"
    system bin/"AnnotSV", "-SVinputFile", testpath/"input.bed",
           "-annotationsDir", testpath/"annotations",
           "-outputDir", testpath, "-outputFile", "output.tsv"

    output = (testpath/"output.tsv").read
    assert_match "AnnotSV_ID\tSV_chrom\tSV_start\tSV_end", output
    assert_match "1_100001_200000__1\t1\t100001\t200000", output
    assert_match "TESTGENE", output
    assert_match "NM_000546", output
  end
end
