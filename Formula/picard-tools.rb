class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/2.18.9/picard.jar"
  sha256 "7efe60795cad21865301a9f8de2ce6aad1e1e90c92c69799655e7e5d0effbe56"

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
