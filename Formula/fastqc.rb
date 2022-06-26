class Fastqc < Formula
  desc "Quality control tool for high throughput sequence data"
  homepage "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
  url "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip"
  sha256 "15510a176ef798e40325b717cac556509fb218268cfdb9a35ea6776498321369"
  revision 1

  livecheck do
    url "https://www.bioinformatics.babraham.ac.uk/projects/download.html"
    regex(/href=.*?fastqc[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae41c7f995b1200ba6dddc708af5b5ced03a817515b7d2fb2a6ec6104ed7c94b"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    chmod 0755, libexec/"fastqc"
    (bin/"fastqc").write_env_script libexec/"fastqc", JAVA_HOME: Formula["openjdk"].opt_prefix
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
