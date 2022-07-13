class Fgbio < Formula
  desc "Tools for working with genomic and high throughput sequencing data"
  homepage "https://fulcrumgenomics.github.io/fgbio/"
  url "https://github.com/fulcrumgenomics/fgbio/releases/download/2.0.2/fgbio-2.0.2.jar"
  sha256 "85a01664fc8c3aa853d636ce8975c25c11d87352d7878e877af5f6a5bb1b3dce"
  license "MIT"

  depends_on "openjdk"

  def install
    libexec.install "fgbio-2.0.2.jar"
    (bin/"fgbio").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -Xmx4g -XX:+AggressiveHeap $JAVA_OPTS -jar "#{libexec}/fgbio-2.0.2.jar" "$@"
    EOS
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
