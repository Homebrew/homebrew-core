class Fgbio < Formula
  desc "Tools for working with genomic and high throughput sequencing data"
  homepage "https://fulcrumgenomics.github.io/fgbio/"
  url "https://github.com/fulcrumgenomics/fgbio/releases/download/2.3.0/fgbio-2.3.0.jar"
  sha256 "a0748b52a92403d88e7cf799368c313a05f89c5e3da04f7f8829593a603b7c69"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba3907dc5fda2b24deca3a51499aaec67019d05ab69ce113a2a4957e42fdc15d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba3907dc5fda2b24deca3a51499aaec67019d05ab69ce113a2a4957e42fdc15d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba3907dc5fda2b24deca3a51499aaec67019d05ab69ce113a2a4957e42fdc15d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba3907dc5fda2b24deca3a51499aaec67019d05ab69ce113a2a4957e42fdc15d"
    sha256 cellar: :any_skip_relocation, ventura:        "ba3907dc5fda2b24deca3a51499aaec67019d05ab69ce113a2a4957e42fdc15d"
    sha256 cellar: :any_skip_relocation, monterey:       "ba3907dc5fda2b24deca3a51499aaec67019d05ab69ce113a2a4957e42fdc15d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "754dc7f09dca98fd6256e8afe2d971110013ad97df80759843b612ae69894479"
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
