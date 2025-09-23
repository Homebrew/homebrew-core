class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.3.4",
      revision: "d0d0a12c18f2839b7342711a0e030f9a497919de"
  license "Apache-2.0"
  head "https://github.com/uber/cadence.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00047a3db89fd3bd66dfbe4596b16d1b1d499e51db19736158c080ac69f8dd2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eb5919cd1d6822d328819e2b899d28f3a1e42804ce86cce12fecba09cb9de84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf6ebca800e4e2c152aa2399e4ed52c70b52275f192a300132893485ab7ff4fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41b893829c73e3ada29870b2f52f3118b2b9a24ec07312f98002b361aa7c97e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "08b8d6ee1e5f5454d7a81f5259397bead8512ee78020f02d98727f858596c7ba"
    sha256 cellar: :any_skip_relocation, ventura:       "202b552ae8c047ffefeab511b5a0500afda246936eaf43fe616b0fa7169636ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcc94d41871ba78412b70cacfbf10d2b5f481d4bebbd16c19bbf858cdbb6a688"
  end

  depends_on "go" => :build

  conflicts_with "cadence", because: "both install an `cadence` executable"

  def install
    system "make", ".just-build"
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
    assert_match "no config files found within ./config", output

    output = shell_output("#{bin}/cadence --domain samples-domain domain desc 2>&1", 1)
    assert_match "Error: Operation DescribeDomain failed", output
  end
end
