class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v0.24.0",
      revision: "517c6c135a24a4f23eea6f3a3747e14e59b5d49e"
  license "MIT"
  head "https://github.com/uber/cadence.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bb14f3835afb8190771c3bf2e42dd958c177221047f8b46a504304a1ab4d293"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fa1a09734fdaa7f52b0acfccb58c3edd520789f209d5d8d438b853551f8e45f"
    sha256 cellar: :any_skip_relocation, monterey:       "cf5cf6fa405398d5524c78983bc2b2e7a21d4912891a3c87dfe99eac6d081b96"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a60a393e42cb55466540616f32322fadab3b81d007f62d58205cedcac37be54"
    sha256 cellar: :any_skip_relocation, catalina:       "473b4fb0483ddecdeb64e04f6714988e7be0e19bce25d40bb35c0d322dffc645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eac15bfbfd057c587bde6b4beb996a526afa51d94cc8328b4eddb9d7ff9ca244"
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
