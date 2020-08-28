class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/2.23.3/picard.jar"
  sha256 "0eae556a8f925d0790d9df2c94b7df323a0107eecdd6ac45866c391921888f23"
  license "MIT"

  livecheck do
    url "https://github.com/broadinstitute/picard/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "picard.jar"
    (bin/"picard").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" $JAVA_OPTS -jar "#{libexec}/picard.jar" "$@"
    EOS
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCT
      CTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    cmd = "#{bin}/picard NormalizeFasta I=test.fasta O=/dev/stdout"
    assert_match "TCTCTG", shell_output(cmd)
  end
end
