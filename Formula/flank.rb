class Flank < Formula
  desc "Massively parallel Android and iOS test runner for Firebase Test Lab"
  homepage "https://github.com/Flank/flank"
  url "https://github.com/Flank/flank/releases/download/v23.06.2/flank.jar"
  sha256 "64b69c79ccc44e8bb3c1ab8c442871e3e1b7251f2fdf36343b7375fbe72430b0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "900668858605c5d4c1ff1b758cf497bf85478af8903eaadf64d5ad9d392a3908"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "900668858605c5d4c1ff1b758cf497bf85478af8903eaadf64d5ad9d392a3908"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "900668858605c5d4c1ff1b758cf497bf85478af8903eaadf64d5ad9d392a3908"
    sha256 cellar: :any_skip_relocation, ventura:        "900668858605c5d4c1ff1b758cf497bf85478af8903eaadf64d5ad9d392a3908"
    sha256 cellar: :any_skip_relocation, monterey:       "900668858605c5d4c1ff1b758cf497bf85478af8903eaadf64d5ad9d392a3908"
    sha256 cellar: :any_skip_relocation, big_sur:        "900668858605c5d4c1ff1b758cf497bf85478af8903eaadf64d5ad9d392a3908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24ca1d30ebf6c9561a291bd790df8703897b578bb002dd40090bee9f00752d1d"
  end

  depends_on "openjdk"

  def install
    libexec.install "flank.jar"
    bin.write_jar_script libexec/"flank.jar", "flank"
  end

  test do
    (testpath/"flank.yml").write <<~EOS
      gcloud:
        device:
        - model: Pixel2
          version: "29"
          locale: en
          orientation: portrait
    EOS

    output = shell_output("#{bin}/flank android doctor")
    assert_match "Valid yml file", output
  end
end
