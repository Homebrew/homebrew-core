class Orgalorg < Formula
  desc "Parallel SSH commands executioner and file synchronization tool"
  homepage "https://github.com/reconquest/orgalorg"
  url "https://github.com/reconquest/orgalorg.git",
      tag:      "1.2.0",
      revision: "5024122fb3efaad577fa509e2d17aab1f12217de"
  license "MIT"
  head "https://github.com/reconquest/orgalorg.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96c0e16b29df9e9001a2dfa6b52f75ed29a6c1f0364c471ee8d2bbe6d219d7ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94c8876f125804235f739721fd76b638142a2d201efa722f80ed9dca67a2bc71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d351128a7c84c2719ab26b2ff7f4188d8cc511bdd05a9abccaf674ded52baf7f"
    sha256 cellar: :any_skip_relocation, ventura:        "b1c2fb13e6c3b0764c4b7fbf450b5d5c71e39def12efb6685ab281e4f1df3ad0"
    sha256 cellar: :any_skip_relocation, monterey:       "04019263a064a9c259854951945c31a84ded8847475f607e1452cfaf3d003ed9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8263d34464253c4bf541e8ad30e1a42fa62c41ec3e1827300fa46192bcb8140"
    sha256 cellar: :any_skip_relocation, catalina:       "3a76493500a6daa3401c0dba2107f63811794913d621150d391069c44ca9a7a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4612ae3bbd7a798fe80217712774e26bc96b044de4b8aa147baa2e6b93e0dea2"
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
