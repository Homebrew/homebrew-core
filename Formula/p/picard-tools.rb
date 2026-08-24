class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/3.5.0/picard.jar"
  sha256 "b7d97861c3a54ba5a421f5a317f38382f955803862d30ef4aca2bcdc54943631"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ccbe234ab7b0642822fae316e80b74614b4ca908c5abf3c203260d9ff28d50da"
  end

  depends_on "openjdk"

  def install
    libexec.install "picard.jar"
    bin.write_jar_script libexec/"picard.jar", "picard", "$JAVA_OPTS"
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
