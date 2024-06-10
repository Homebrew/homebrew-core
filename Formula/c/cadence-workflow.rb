class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.2.10",
      revision: "02c7efbed448c4a493b3a971e8e0e292e17c6d91"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da1eb178d76e6f3c23a9471a3f20b0161201ebf8fa7690d749251568c8265adc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ce3b5713369952eeae32b2d6f23e9f92f7461af51c6aaf348fe91a5e752d9c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc7c85627c4c0bdeb65984f33b5d26b425980caacb590673e24dbe640f595d56"
    sha256 cellar: :any_skip_relocation, sonoma:         "6655042e61172c81ab0a59f9a62821409d04aa95d8c802f970ab90b36e1ac8d9"
    sha256 cellar: :any_skip_relocation, ventura:        "98ce403f94fbcd95976fbdc963be2e4870bc75a89f0fb0858d486b2e69687795"
    sha256 cellar: :any_skip_relocation, monterey:       "9e758b88e4033c4c1b77607958560cc3ae3119381cef40188b0dd7f04aa02c34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd322923d95883a5cae17b819c7bc1a5d7de753f814811071090f9d43cc23a2c"
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
