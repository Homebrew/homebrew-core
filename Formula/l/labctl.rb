class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.106.tar.gz"
  sha256 "7e51aea65c0a7c4c7d60ac5a131c728597b6649db0d4cf1dec8110565ab5022a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "992b447686c457dea8ffa970f1495ca41050b5fbb865a1c9d4100d208a9373ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "992b447686c457dea8ffa970f1495ca41050b5fbb865a1c9d4100d208a9373ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "992b447686c457dea8ffa970f1495ca41050b5fbb865a1c9d4100d208a9373ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "7595552117478e7f532c59fecbc645d3b49c057e3d1c2103637ca8c16c6d1083"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfb4779d7006257026f3189b592019c80f3e17029076ac1c84fc99c177545e24"
    sha256 cellar: :any,                 x86_64_linux:  "e406ba296a7cc10f794176854806d0b8d3e7fa805c8081eae8b993fa2dc8c711"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
