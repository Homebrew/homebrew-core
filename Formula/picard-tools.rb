class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/2.27.5/picard.jar"
  sha256 "131ca3e0626a3ef12e8399795e7a49f829bb4e85d71b489bf4f231d21a6c3199"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c87428a462195f7d5d8912f9f6e4344ada16e075aa9b083a559a732227774848"
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
