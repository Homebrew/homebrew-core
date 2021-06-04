class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
    tag:      "v0.21.0",
    revision: "667b7c68e67682a8d23f4b8f93e91a791313d8d6"
  license "MIT"
  head "https://github.com/uber/cadence.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8e1850323d0cad6a3f44473ff4aaef105184612d7722f50d1873a7da7316679a"
    sha256 cellar: :any_skip_relocation, big_sur:       "c6dab9ef8e9cb3c7f132f7b5a38220b44d2ed67ef3ad8c4e40254203cd6e36e8"
    sha256 cellar: :any_skip_relocation, catalina:      "5ce8a6e9023ae8e94fd0a050b1eea6c8e6f66d825efd424f6cf684deadbef854"
    sha256 cellar: :any_skip_relocation, mojave:        "55181a06191e4d5e71a954330db3366a26cbf210e6bc53fb7e6ad3cbc9b045ab"
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
