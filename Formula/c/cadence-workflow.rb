class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.2.11",
      revision: "83ebf7a29d5f3738b9e496e97f26921b032e53cb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0458d1ecfa95e081bc5764654e72f68f79ed9c9108090bdad4ea2c53bc3f39a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f892e4b9c56294675696264041f3aa25a3ada69d2b5f2f0c9f3c0f0684dcbc07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d2b8655954c861b7fc06813468869a0c950f4dd287c5ee631bcdf29d5ebb5d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "4966a4783190cd6b1920f1e1fb6fd38efb19aa8de420e0972ca97e220ce60780"
    sha256 cellar: :any_skip_relocation, ventura:        "71e96348f2e4d38d0b7792e329df67a32e7dd4a6ac41bb49a92c07ca72bc2d56"
    sha256 cellar: :any_skip_relocation, monterey:       "5d10b9d96e129ee1ff029a2bf63dd1574a4c4e7652a103c33c91fb2365b064bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52283ad36088aef894de7523a17a01880614ccc0a83632d92c2115f52af8370d"
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
