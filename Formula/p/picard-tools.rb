class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/3.4.0/picard.jar"
  sha256 "e76128c283889fc583c9dea33a3b7448974c067d102c9e35be152642d4d5f901"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7fbf17eca625e75fd79d09a89ba7f763725b0d3e669a6e53de7ac574b38f2e6f"
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
