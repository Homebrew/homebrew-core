class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "1cdffbee29d9455a0ff4e61114f93b1f5fc210366b707b7dd496a90325a21dce"
  license "MIT"
  head "https://github.com/uber/cadence.git"

  depends_on "go" => :build

  conflicts_with "cadence", because: "both install an `cadence` executable"

  def install
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
