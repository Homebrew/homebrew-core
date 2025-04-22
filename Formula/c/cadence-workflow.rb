class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.2.18",
      revision: "2c2a590515c6171ae44ed618f432d9c85295201f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b173a18fd73d5a851b4418dd2a6ea1394920a4cdc6b97eced1b4bb0b6dbf88f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd9859d0965962a14bdc42ba123fbc743fcfcf3a523f346f857c414dd707c4ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aaf2d5e4a9957eb6362abb783a34f87598bd723db3e3cb1b75d042e304dc0e33"
    sha256 cellar: :any_skip_relocation, sonoma:        "8af4e60f8cdbc1d7c425ece5a63cccfca1c0925b96c7d223496f7e82793ed972"
    sha256 cellar: :any_skip_relocation, ventura:       "dfff6e9231a98e8ecdb3870d2cc804e717b19492379b8038735a325398b5e019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb3e643a85d61d84b769e863cace4f18207c7372eeebb54f7aa526142b461ba0"
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
