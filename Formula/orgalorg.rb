class Orgalorg < Formula
  desc "Parallel SSH commands executioner and file synchronization tool"
  homepage "https://github.com/reconquest/orgalorg"
  url "https://github.com/reconquest/orgalorg.git",
      tag:      "1.2.0",
      revision: "5024122fb3efaad577fa509e2d17aab1f12217de"
  license "MIT"
  head "https://github.com/reconquest/orgalorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91ad3f394a710d6f7aa6fede2ce37b21eb10ba5468c92cb33438b5eb3bb2dc3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73d99bd8ed8831a00ecc07f6f700025be10c43d89cf33c18ccb1cd7f9de832ab"
    sha256 cellar: :any_skip_relocation, monterey:       "c6da69f7ae186443e822d2705aba153ae2b13b298df2fb6c75e29a14b2f5d31c"
    sha256 cellar: :any_skip_relocation, big_sur:        "63b9299de9ec2e76a4e08c513cc112d79ba10315d1aa38040481f5476ced9bdc"
    sha256 cellar: :any_skip_relocation, catalina:       "a3dfaacf2a623eedfc3ada1459a74d68422b7e1023fd80ada0d4eadae219c1d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea81b423ead484325c0b7b5480d14f11664cb1321c1c67434190a38ca3ca877a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=mod", "-ldflags", "-s -w -X main.version=#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orgalorg --version")
    assert_match "orgalorg - files synchronization on many hosts.", shell_output("#{bin}/orgalorg --help")

    ENV.delete "SSH_AUTH_SOCK"

    port = free_port
    output = shell_output("#{bin}/orgalorg -u tester --key '' --host=127.0.0.1:#{port} -C uptime 2>&1", 1)
    assert_match("connecting to cluster failed", output)
    assert_match("dial tcp 127.0.0.1:#{port}: connect: connection refused", output)
    assert_match("can't connect to address: [tester@127.0.0.1:#{port}]", output)
  end
end
