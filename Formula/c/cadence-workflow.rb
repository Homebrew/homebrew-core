class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.2.9",
      revision: "ba396780a64146a9d4092e4363bc9df5d851f711"
  license "MIT"
  head "https://github.com/uber/cadence.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b9b57c487b864fc9a1ad0850655b3886954831677f6512268638729d04fa930"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e74e1f042676ad748a000968ddf306be6a155117a9a9c7c66de5e941c6c77ce6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "870ef8815545f870175e4a5038ae7eec46a8f5f5b4683fb3473d56c790444d09"
    sha256 cellar: :any_skip_relocation, sonoma:         "1be8b0d9c7f35bb6a96dddfbeba36798cc91cce26b7c3428268104d1f7c91424"
    sha256 cellar: :any_skip_relocation, ventura:        "3d64daaa072ba8f5334f76450793fbf93766a2952493519ce224fb7f8f73d094"
    sha256 cellar: :any_skip_relocation, monterey:       "df44ab307c879dbee5282346c005071218ceae8c81df2603d045c2c65895fb5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "486bdacfcb011feca8f30f5a9f7b222125fba7d14c33968bd914f043c5b49963"
  end

  depends_on "go" => :build

  conflicts_with "cadence", because: "both install an `cadence` executable"

  def install
    # `go` version is hardcoded in Makefile
    inreplace "Makefile" do |s|
      s.change_make_var! "EXPECTED_GO_VERSION", Formula["go"].version.to_s
    end

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
    assert_match "Loading config; env=development,zone=,configDir", output

    output = shell_output("#{bin}/cadence --domain samples-domain domain desc ", 1)
    assert_match "Error: Operation DescribeDomain failed", output
  end
end
