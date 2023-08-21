class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/3.1.0/picard.jar"
  sha256 "ea79ca6279a5e818cb6fa68a3476dde799c7ea03ffe52a26a3ca68c71ef28559"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b907079bb51dd225d5cc4cd2686daa51374f8b05a93dd4130704b048f1b841c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b907079bb51dd225d5cc4cd2686daa51374f8b05a93dd4130704b048f1b841c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b907079bb51dd225d5cc4cd2686daa51374f8b05a93dd4130704b048f1b841c2"
    sha256 cellar: :any_skip_relocation, ventura:        "b907079bb51dd225d5cc4cd2686daa51374f8b05a93dd4130704b048f1b841c2"
    sha256 cellar: :any_skip_relocation, monterey:       "b907079bb51dd225d5cc4cd2686daa51374f8b05a93dd4130704b048f1b841c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b907079bb51dd225d5cc4cd2686daa51374f8b05a93dd4130704b048f1b841c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c081df7f1b8c4c699aaa5e99381eeb99085416cdd1145a9c8df4613b89c732b5"
  end

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
