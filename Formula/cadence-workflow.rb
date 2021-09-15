class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v0.22.0",
      revision: "ec3596a5ecb80708584d90e04c07fc35b6aa3668"
  license "MIT"
  head "https://github.com/uber/cadence.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9e16a38ef7c0732bf998ca483ebcbe63acb27aba3b4af1df7ead06872d7799ae"
    sha256 cellar: :any_skip_relocation, big_sur:       "9f0acf7884bd1d05db0b0883357f359f3772990acb2224721b451538003c1277"
    sha256 cellar: :any_skip_relocation, catalina:      "7c561ec4abd26335049a865ca2e929d8df73e3837b9028052ee738940730c3f4"
    sha256 cellar: :any_skip_relocation, mojave:        "805f5604c6a4c02df187b8463549aa17f813cc85a47f40009c15081b8983b389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14ce5267bef1e9dfd0f2399927e48801fea69e2d1157b755058d3e4bb723c4a0"
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
