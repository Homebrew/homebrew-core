class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/2.21.2/picard.jar"
  sha256 "89be6d0fec5e4bf0a82db0aa17728e5f15d13456dcf9e7f75dd3af9901895700"

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
