class Fgbio < Formula
  desc "Tools for working with genomic and high throughput sequencing data"
  homepage "https://fulcrumgenomics.github.io/fgbio/"
  url "https://github.com/fulcrumgenomics/fgbio/releases/download/3.1.2/fgbio-3.1.2.jar"
  sha256 "e61973d4d700c024ed29c4fe7b06286756d9582f71193decfbd16e17904fd63d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a16bf76558f998bf34005e2a23d2e25d77ee15242f21d33027868c2cbc58f1a8"
  end

  depends_on "openjdk"

  def install
    libexec.install "fgbio-#{version}.jar"
    bin.write_jar_script libexec/"fgbio-#{version}.jar", "fgbio"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCT
      ctgtgtggattaaaaaaagagtgtctgatagcagc
    EOS
    cmd = "#{bin}/fgbio HardMaskFasta -i test.fasta -o /dev/stdout"
    assert_match "AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN", shell_output(cmd)
  end
end
