class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.2.13",
      revision: "f6e4360c99e083e4b64c7b3b3e781c8205074e79"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "205a9723f7e6df58788e4877f7bb2c10f01523954eebb6aa3a72ba0ba638e971"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8745c730e6d878189ec1c5b7bc3ced909127323cd1603d09996cdce6349916e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92d5c58f4c29946bcc120b4f16fbd3d72672cf46d4ee3bb6f3df7f88eaea2cb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef3dc802ab13fc51e00722a4a699d0ff1df040162505eb94762fcf86b3a4e747"
    sha256 cellar: :any_skip_relocation, ventura:       "204e80cbaa6284a7f5198f98f411c815b988ed4b0cb82e3ee7accfd8298e844b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f2ac143064b276e89649214a4ba8b344bfcfbca905b5157a8d041e1319af38f"
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
    assert_match "Loading config; env=development,zone=,configDir", output

    output = shell_output("#{bin}/cadence --domain samples-domain domain desc ", 1)
    assert_match "Error: Operation DescribeDomain failed", output
  end
end
