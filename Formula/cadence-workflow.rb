class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.0.0",
      revision: "8e81044769ddd11a10db66795b98146687beeb41"
  license "MIT"
  head "https://github.com/uber/cadence.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ce961c1122cdc0732910ec4fbc06fd7c096d0c37b1d65afd09b9fc0342a296d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5022de5575b51b8cb3a0e9813807d3a11bde1ea278dcb9f8bfc3cbe73e8364d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44040ca896a9935700ed223beeab382585035ac042318a7039c9dbf1a2db46cb"
    sha256 cellar: :any_skip_relocation, ventura:        "0730212aa8a3b72c8629bbfb11aff5f946a42c83e0826c3fcd54ab2f06167e34"
    sha256 cellar: :any_skip_relocation, monterey:       "5bca930b8af208fa04d4da776ae0760128f6f2132be11a7410c28ab679e54aa2"
    sha256 cellar: :any_skip_relocation, big_sur:        "46e3cdae35e96ddced80e4634cf9c6db0883ac60574568ed4726d7bcdc99b49a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9d005b5fd4eb46630e4d51e70328c573bfda1c117f27009782c950a44755535"
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
