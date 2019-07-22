class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/2.20.4/picard.jar"
  sha256 "317d28e455c5d843a3fc52e583f9ac6c031979ffb949c555a227a20931bf5ffc"

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
