class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/2.20.7/picard.jar"
  sha256 "32f800e4f1023dfc0495b91658e79e460a3b3054cc1f903c7ea7c6a59cc82be4"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install "picard.jar"
    bin.write_jar_script libexec/"picard.jar", "picard"
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
