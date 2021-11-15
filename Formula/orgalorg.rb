class Orgalorg < Formula
  desc "Parallel SSH commands executioner and file synchronization tool"
  homepage "https://github.com/reconquest/orgalorg"
  url "https://github.com/reconquest/orgalorg.git",
      tag:      "1.1.1",
      revision: "c51061ef46e1ba8e4eafdb07094287721c6a18cd"
  license "MIT"
  head "https://github.com/reconquest/orgalorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aef096f46e7f1b3e73550cdf36718bf4b2b9930f7ab492a82665de8f5f1a81df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14f5394a84d3ae2ef72ff633b5afb8e011f43fd216ce5f01ccb23bce6d3ca226"
    sha256 cellar: :any_skip_relocation, monterey:       "4110c9de1aa1955a423499e00ae4679b16c00c9cd3c0f03dfdeb20d5c86dc0d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ee602e0813c28324540867783c06e6893e3ea775ea645c091212d90c7c41c9f"
    sha256 cellar: :any_skip_relocation, catalina:       "6e241d28394d4b0f590088dbd65c06403c460d407885429ba459ab4aa2f6ccb2"
    sha256 cellar: :any_skip_relocation, mojave:         "b0a92196ed8cf01b592c724da59f22c3695e6799f170301dbee6f4bb1bb95c95"
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
