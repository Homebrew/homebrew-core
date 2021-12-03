class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v0.23.2",
      revision: "8dd7a0818dfe6a09c25bf8a7afd267834262f625"
  license "MIT"
  head "https://github.com/uber/cadence.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c35fe4f1db7f2585a890fe0a699c5b288b865d812aaf56cfc64994b9d1ea304"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40796bd33fd44973a54764f36beb291d4f7077cc20c6ee4c9f487d98744481c8"
    sha256 cellar: :any_skip_relocation, monterey:       "dc9d76f3f1d1ddc65cfa71272e1d0ac69da02dd4d460226ff17125db9471cad9"
    sha256 cellar: :any_skip_relocation, big_sur:        "722efad8f34126bf0dedee1a6fc6c6db63827f216e3fd27cf961392ae695cd27"
    sha256 cellar: :any_skip_relocation, catalina:       "dda2df6a2386681b40d70aadee2663ada5f0cd8f70ac6bf7c7824568c605eabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4361ae05248c9d2917a73acb07b92512374180791c4a722aac9c06c5d492fd1"
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
