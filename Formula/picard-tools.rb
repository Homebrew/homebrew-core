class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/2.18.11/picard.jar"
  sha256 "09adee14d1585951cf25bd32df79c8e18804324d1faeaaf8427674b9c6f7930f"

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
