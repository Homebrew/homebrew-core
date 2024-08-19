class Fastqc < Formula
  desc "Quality control tool for high throughput sequence data"
  homepage "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
  url "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip"
  sha256 "5f4dba8780231a25a6b8e11ab2c238601920c9704caa5458d9de559575d58aa7"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.bioinformatics.babraham.ac.uk/projects/download.html"
    regex(/href=.*?fastqc[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b55cf3f17b3c62267f72029429f662fe70e19c817bbe61872f7b85b5149d7564"
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
