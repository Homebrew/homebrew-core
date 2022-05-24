class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v0.23.2",
      revision: "8dd7a0818dfe6a09c25bf8a7afd267834262f625"
  license "MIT"
  head "https://github.com/uber/cadence.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef8e7402bb8faf6ea72912ff73c23ae2f1f781617262e47d19e5e01431696904"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "991901030b3749680647ffd9905a56d453ae08367af98ab5301ea5a254c9d32a"
    sha256 cellar: :any_skip_relocation, monterey:       "8ae85ecc77a31a57b613a738932054dada5a3ad72dfe34a9ac33e23ca740dd95"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee9783f62aca85ea20088527eaad3388a4ec7a86ad50abdafe7b0d5bfdf60bf5"
    sha256 cellar: :any_skip_relocation, catalina:       "e339d65a3e64a50c08ca52ea176437269c5997adf4aac57bb73e98750a9caa1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44af732c1f0aa4a58ae66844ef5e2926d2376997de028e6167461d84a56130ea"
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
