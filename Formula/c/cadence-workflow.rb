class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/cadence-workflow/cadence.git",
      tag:      "v1.4.1",
      revision: "3410187d214d4b6bc19fd74e34b8cb11d112f93c"
  license "Apache-2.0"
  head "https://github.com/cadence-workflow/cadence.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83967799528abc05e2d8d4cdc63eb2310a26eabdee9103ed2fe6d8f162ade0af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "940105d1f7548ae8aac4e1c36014c2d0dc6f668fa6ce43247fe8864a4b734b4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fe5ed3fc9fe5ebf020dda5d58892915aed73725deb67854e596837e755448b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "66c97e89bc92c2b3b032493454c80f44591c4dde2f5161980b4b8e04548ca374"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc8686c857b14d9a8bf8c01e4dba2a1f02146e95803cafa3e93579e16d55e51e"
    sha256 cellar: :any,                 x86_64_linux:  "d5d49406904313d8865c861eaafddbbb850d7feab408b8aead5f14e8a078be5b"
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
