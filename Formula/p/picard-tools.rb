class PicardTools < Formula
  desc "Tools for manipulating HTS data and formats"
  homepage "https://broadinstitute.github.io/picard/"
  url "https://github.com/broadinstitute/picard/releases/download/3.1.1/picard.jar"
  sha256 "15c79f51fd0ac001049f9dd7b9bac1dbdf759dcb0230a89c7f6d1f246e8bbab4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6d4384bf8e7db693cfc1abf288c23df975101696e0d2b233563c7f592ddf5ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6d4384bf8e7db693cfc1abf288c23df975101696e0d2b233563c7f592ddf5ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6d4384bf8e7db693cfc1abf288c23df975101696e0d2b233563c7f592ddf5ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6d4384bf8e7db693cfc1abf288c23df975101696e0d2b233563c7f592ddf5ec"
    sha256 cellar: :any_skip_relocation, ventura:        "b6d4384bf8e7db693cfc1abf288c23df975101696e0d2b233563c7f592ddf5ec"
    sha256 cellar: :any_skip_relocation, monterey:       "b6d4384bf8e7db693cfc1abf288c23df975101696e0d2b233563c7f592ddf5ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a28bf7a2ec15062ff9d3c84f4a02d15750e1ca95905423fac2318e79314d989"
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
