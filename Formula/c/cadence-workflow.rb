class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.2.8",
      revision: "3f641763552a24ac973d4606a47ff4bba463dbb5"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18d1a5caf02290544fb30788a4e08de52849e7d1efd3ef4e2335060d10b56b85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cdbb7fd56941d3c753386f392d1ea57c0f8ebd422fa73407a78f3b3bb0b0f50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfbf57d402d6e6e72d4a0f498365791d02d3969dbecc7f23c3c285a93190352e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e13457d646ade5c6875c32094c6860b1582f1b228629db42cda3c4af951fd722"
    sha256 cellar: :any_skip_relocation, ventura:        "2cdad7a6bb217b369db256adb5bb74c801cc8336c2e29b3b44e6cb062da0290b"
    sha256 cellar: :any_skip_relocation, monterey:       "7d6095bfb8b55d20d803ff4136aca40b5c8000095f2e75b012acfc18c5713e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3bf94613e4ad2e0806d20cc9e8c93d3fda686c92fe31cc7bb0c22636458f374"
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
