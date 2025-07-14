class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.3.2",
      revision: "ec5588f2f0658f9cb10d1a3fd83935134271e2e3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c38d1ddfc25574a171718aa9c3b2883480529e2bbc33c11123b00431076141a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b834a124096d6ffef2037d9dbf109437d60c314ed5dcb3d0a257258c872f604"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13c1f49c24bb2e19f7a6b2c3a4a2a61f699cb44a94ea4e3591f5dc3d21bfd02c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea8f99436fedcc52f9c091a5606eafcfaa889c6bd7f57026586776f365d6d69a"
    sha256 cellar: :any_skip_relocation, ventura:       "21e3eba05735d677450753ab1f50cdfcb357c72a2c97de40ce1870cc76a9cddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7380d5f7f8fe41547759c05d0109db9437cdb58dfac55190bdac2be6bc7aa50d"
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
