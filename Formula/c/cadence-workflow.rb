class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.3.5",
      revision: "05fe19c2983cc1334c9bb6f92a2687de24ebf6b6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a59590040ad0c66b6f5ae455223989f93d81dcb1747fff92dc104df3621648b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08b92319418ae620df0e9c739e14b406fa0da2712f476acaf801107ed7318db9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "163b04b3bb02ea13972832f21a7e00e2b8e13328259c0b5b64d3f8c6dcf69f9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "abfced27d538d1cc53d11b46e9385058d030548d9961a9730643571f1c87d40c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "141bc9f6e7644423b3eca4efd2aadaf699a431986f64924037b782408edf042b"
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
