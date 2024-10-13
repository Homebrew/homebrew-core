class Fgbio < Formula
  desc "Tools for working with genomic and high throughput sequencing data"
  homepage "https://fulcrumgenomics.github.io/fgbio/"
  url "https://github.com/fulcrumgenomics/fgbio/releases/download/2.3.0/fgbio-2.3.0.jar"
  sha256 "a0748b52a92403d88e7cf799368c313a05f89c5e3da04f7f8829593a603b7c69"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "53161ea2e9d7dbeab3949ba66e631d5184106c4c1b4b133466f8bd4eb7e5b9e5"
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
