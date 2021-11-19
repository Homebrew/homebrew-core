class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v0.23.1",
      revision: "26189983350a9525153c8428083ac7f7cd271390"
  license "MIT"
  head "https://github.com/uber/cadence.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d498024d06a2beace356d6b97402e7ea5c40ba66705e561ba0d28f6ecafdfeb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fba317a3c6b9287e44cf750b8a697a89150cd3e76eaffb90b4d13bbc5de100c4"
    sha256 cellar: :any_skip_relocation, monterey:       "47bdac851ea25a15dbb1a95642f831892f50a7a99b5c99f470e323ef45a1ca4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "09949e14f797cf44a276abb5720010f69615723a82bea93244e9345dd98742b8"
    sha256 cellar: :any_skip_relocation, catalina:       "b42f8242f8e8c65edf5a3778f05c82810da6ba4915fe73810ad450e41fd75e91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e52b35d235d1ece0ffe6a72b2f61279b4d76907fad599be44ef0d2607fad7ee6"
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
