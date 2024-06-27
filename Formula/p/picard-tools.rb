class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/3.2.0/picard.jar"
  sha256 "e258fa2e3f5fa61cd6799ec8e073f49a95fbdceaf163d8a60971b2619b86fa41"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4c4f0a02455e8f496ce952efb7bed2beafd51f136c886b7bf9001b4e493c2a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4c4f0a02455e8f496ce952efb7bed2beafd51f136c886b7bf9001b4e493c2a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4c4f0a02455e8f496ce952efb7bed2beafd51f136c886b7bf9001b4e493c2a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4c4f0a02455e8f496ce952efb7bed2beafd51f136c886b7bf9001b4e493c2a7"
    sha256 cellar: :any_skip_relocation, ventura:        "b4c4f0a02455e8f496ce952efb7bed2beafd51f136c886b7bf9001b4e493c2a7"
    sha256 cellar: :any_skip_relocation, monterey:       "b4c4f0a02455e8f496ce952efb7bed2beafd51f136c886b7bf9001b4e493c2a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "265f23c9a206ed3b31151e2e1f3088e0fc872c3f0389bb79d93d6a412d528891"
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
