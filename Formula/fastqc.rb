class Fastqc < Formula
  desc "Quality control tool for high throughput sequence data"
  homepage "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
  url "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.7.zip"
  sha256 "59cf50876bbe5f363442eb989e43ae3eaab8d932c49e8cff2c1a1898dd721112"

  bottle :unneeded

  depends_on :java

  def install
    libexec.install Dir["*"]
    chmod 0755, libexec/"fastqc"
    bin.install_symlink libexec/"fastqc"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      @SRR098281.1 HWUSI-EAS1599_1:2:1:0:318 length=35
      CNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
      +SRR098281.1 HWUSI-EAS1599_1:2:1:0:318 length=35
      #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    EOS
    assert_match "Analysis complete for test.fasta", shell_output("#{bin}/fastqc test.fasta")
  end
end
