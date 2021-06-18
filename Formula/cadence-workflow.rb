class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
    tag:      "v0.21.3",
    revision: "36cfde8b88b17e2ff0f810e72c808ccfdc2e97f5"
  license "MIT"
  head "https://github.com/uber/cadence.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "029e2c39a8c5999af05be8351e943f1c31e4f091d0705ea73fa23053c57fc782"
    sha256 cellar: :any_skip_relocation, big_sur:       "691b59d7e0ec2fe98739fb1638a0e3c8fc2512ce4d023eabf890735d63b6ccd3"
    sha256 cellar: :any_skip_relocation, catalina:      "ba3630fe181d40f02363becce7696f6d5d71ff75e62c3aadfd16ecc888c9008e"
    sha256 cellar: :any_skip_relocation, mojave:        "ce5732eb9d3d51158ed74dc547aeaa5195e039497319b527fd7aefa50b4cdd3d"
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
