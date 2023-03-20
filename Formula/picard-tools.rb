class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/3.0.0/picard.jar"
  sha256 "0d5e28ab301fad3b02030d01923888129ba82c5f722ac5ccb2d418ab76ac5499"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf5f1b63e3c5596eef15df70b7a7bb0a2836261a3193a392b63804b4cb41ab76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf5f1b63e3c5596eef15df70b7a7bb0a2836261a3193a392b63804b4cb41ab76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf5f1b63e3c5596eef15df70b7a7bb0a2836261a3193a392b63804b4cb41ab76"
    sha256 cellar: :any_skip_relocation, ventura:        "bf5f1b63e3c5596eef15df70b7a7bb0a2836261a3193a392b63804b4cb41ab76"
    sha256 cellar: :any_skip_relocation, monterey:       "bf5f1b63e3c5596eef15df70b7a7bb0a2836261a3193a392b63804b4cb41ab76"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf5f1b63e3c5596eef15df70b7a7bb0a2836261a3193a392b63804b4cb41ab76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f33b5414ee003d8dd3ca53611b6afc29c49ab66527bf515efba7986ceab9e6e"
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
