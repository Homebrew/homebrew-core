class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.2.6",
      revision: "558780bca0154ce2976f36d91585d8654d24549d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "745d660b8b5c7c5e3a8334ec028d06cec125da2a3c8c0ed0b3a9b13f59febc4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ffd5514a3ec98b7c5623ef09f5c535ed095b53ac04377e6cb7e9d16288c4083"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0403b6d7009320942e7eb9009d41e4e82636c842aa6191be293d735f55e0bc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "47671830a26e35b4d211ef36231ae332da044ff43365fa8efbac118b91e2c524"
    sha256 cellar: :any_skip_relocation, ventura:        "44733fa45ce3c2e0eb01981c90a9b19d1ff3125e5e2d7f7d1afc79fd733b6292"
    sha256 cellar: :any_skip_relocation, monterey:       "301ca3ca33ed789f2070baa40e77b868ca0ab1d667a9f308a842cfb640fcadae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a03aa263f66fa023d9060fb3745a53243d5f4c8b9aec4fdc2495cd1bd2698b25"
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
