class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.3.6",
      revision: "a484e23286beae275868b67c4dffdd639a8646c4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bf90a6d2f25b64bdd63e850cfc5dbdf9b34c0a45da4fefbe00288e257e82267"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41bbf5fee56a823da7d6aaf931bc4fd4e4b6232f02a2a2a3113a109875c7061a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4146169e8e4910ca1b5df6d9cef2ce48f52d80e8170841ae01725536014fd266"
    sha256 cellar: :any_skip_relocation, sonoma:        "fccecee66af960668bb2990e1e8537609186bf8f599fc3b3c0b3f2d9fa164518"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "366aac1b326686254c4b9c03d2d82f3b2d5663ca8648ddba35b35a6bfb3cb88a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c91e03fb9cac3d080357949eb6f76e5205a4211f752ce1525c088ad2c3fa78d"
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
