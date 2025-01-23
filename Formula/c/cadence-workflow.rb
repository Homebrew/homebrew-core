class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.2.15",
      revision: "ab3d41c2694893f72cc8462ad78c566adaa009bd"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8f581e953743385c7006303dc5224738675a156c6bc1ceb122d988aa0a93fa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6a8978cdf8dc2f2c9a2f01800d32b26094a44e2f0bbb1608d8ea31a40c64959"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3793a36b075afb26d1957d02ea637ed3456da336ca30c2082e6b2efe64649f7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdf191c235e2b5c073592f0ff05f6b7831559d74f656c2f5e27c7ac23aa6b6a7"
    sha256 cellar: :any_skip_relocation, ventura:       "bd8088a843bc0361283c6d057f7e0ee310544830996b09ae42186a0eed7862f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d298d1ce1cef8de06bc5a49bdf9844546dce3c6b8d4af33cf3c7d743ecc4ffc"
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

    output = shell_output("#{bin}/cadence --domain samples-domain domain desc 2>&1", 1)
    assert_match "Error: Operation DescribeDomain failed", output
  end
end
