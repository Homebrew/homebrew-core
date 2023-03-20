class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v0.25.0",
      revision: "eb2911866c5c66bdfd8949e533565471899b7ec4"
  license "MIT"
  head "https://github.com/uber/cadence.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba5cebddd1a3e56f30ff1223511140848790f893cbe8c6c313fb3bc9d9cc9251"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bcbee4c17bac0a853653cbc8f2cbad647cff84bf2e793c4092900acf20fc16e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "790744a226e4e23758d8dbfffb033f823e49133081988e54169d1b5c06616197"
    sha256 cellar: :any_skip_relocation, ventura:        "b87177fc6043b776f440a63dd1445664d55b5fa33533a8271a5dc72337aa0d6d"
    sha256 cellar: :any_skip_relocation, monterey:       "4000b32346f71b3ba90857d0ce5022f6e899d132deba42a5f8e1ef09a9d632f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "93f0a964a6227e8a65a537d16e54df81e36b248d473b80aaf7c3caf85c527e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42240c643a6d8047a08d3e1928fcafb6f913bdf30d9815bee58facc77ee44f9c"
  end

  depends_on "go" => :build

  conflicts_with "cadence", because: "both install an `cadence` executable"

  def install
    system "make", ".fake-codegen"
    make_args = %w[
      cadence
      cadence-server
      cadence-canary
      cadence-sql-tool
      cadence-cassandra-tool
    ]
    make_args << "EMULATE_X86=" unless Hardware::CPU.intel?
    system "make", *make_args

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
