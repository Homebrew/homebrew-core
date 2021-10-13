class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v0.22.1",
      revision: "88a53b42f69cec51790d46a9d1b3333cd9a8a382"
  license "MIT"
  head "https://github.com/uber/cadence.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eb11b10bda98b3a84ae70c022fbdd5b21fed571a5e604d33071f92211b407977"
    sha256 cellar: :any_skip_relocation, big_sur:       "2e086ba5ae78d9bbbeb1b7b1498cfa6eadf3a87c7d2f0bb2cdbf6c5e33cce087"
    sha256 cellar: :any_skip_relocation, catalina:      "72006c3ae1010c72e2d429a51f7548a655ad4c5bb5d69560e1f0d278eaf47057"
    sha256 cellar: :any_skip_relocation, mojave:        "ead79d3141d2d7fe840b87350373dc4f030e0d5a2f5878eb07eb1a884e83b9b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8c3240980dcd953ac09934a87bc90d0dcf81148cda854c6a08301659f026e7e"
  end

  depends_on "go" => :build

  conflicts_with "cadence", because: "both install an `cadence` executable"

  def install
    system "make", ".fake-codegen"
    system "make", "cadence", "cadence-server", "cadence-canary", "cadence-sql-tool", "cadence-cassandra-tool"
    bin.install "cadence"
    bin.install "cadence-server"
    bin.install "cadence-canary"
    bin.install "cadence-sql-tool"
    bin.install "cadence-cassandra-tool"

    (etc/"cadence").install "config", "schema"
  end

  test do
    output = shell_output("#{bin}/cadence-server start 2>&1", 1)
    assert_match "Loading config; env=development,zone=,configDir", output

    output = shell_output("#{bin}/cadence --domain samples-domain domain desc ", 1)
    assert_match "Error: Operation DescribeDomain failed", output
  end
end
