class Fastqc < Formula
  desc "Quality control tool for high throughput sequence data"
  homepage "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
  url "https://github.com/s-andrews/FastQC/releases/download/v0.13.0/fastqc_v0.13.0.zip"
  sha256 "c9504d47752e79ecfe61691e09bf367fc3f15167ac3fe83d9e33534fffbcc301"
  license "GPL-3.0-or-later"
  head "https://github.com/s-andrews/FastQC.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c7fe2b894185e522e6d136bc612f491c7fab0f2d5d02c8bd11bb744a3863afd"
  end

  depends_on "openjdk"

  uses_from_macos "python"

  def install
    libexec.install Dir["*"]
    chmod 0755, libexec/"fastqc"
    (bin/"fastqc").write_env_script libexec/"fastqc", JAVA_HOME: formula_opt_prefix("openjdk")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastqc --version")

    (testpath/"test.fasta").write <<~EOS
      @SRR098281.1 HWUSI-EAS1599_1:2:1:0:318 length=35
      CNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
      +SRR098281.1 HWUSI-EAS1599_1:2:1:0:318 length=35
      #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    EOS
    assert_match "Analysis complete for test.fasta", shell_output("#{bin}/fastqc test.fasta")
  end
end
