class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.4.0",
      revision: "1a42a949010b4257020c0641f88cbcd385184bb8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8a3964e7a66146c41e9513dc6c9a1186595e2e80e58ab4b008e146c4d2716b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e2b72d6ad8a73fb6e918794eaaa96d599d51efeffbade48ed933e77bf2f39c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "168814777006447c91ae02f9aa9a6549b4949c6a00f44e1f578f7b16f1fe3d9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "95c75946272ffdeb70ce9265054e41845b8741da3f25b65df63f03adc05aed81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "980bb6386730269f3e5e4c8907cef1f1539e46aa82b908f93db1a54cfde78cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91650d5bac50e659793533f28ab8fc036b77734fc30237d73061be3e6df5b41d"
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
