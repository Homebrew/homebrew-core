class Orgalorg < Formula
  desc "Parallel SSH commands executioner and file synchronization tool"
  homepage "https://github.com/reconquest/orgalorg"
  url "https://github.com/reconquest/orgalorg.git",
      tag:      "1.3.1",
      revision: "17aad3570a15099fc52949ac4359b350f045ca84"
  license "MIT"
  head "https://github.com/reconquest/orgalorg.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dc20b9130dfde0b22594c6e0956e25ca597ad7b8d5bc1fab464fd27265ba9604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06947c8b72e6195a7f44ba80fd5fc0f9b61c5e592de035312365ad85b9c78e37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06947c8b72e6195a7f44ba80fd5fc0f9b61c5e592de035312365ad85b9c78e37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06947c8b72e6195a7f44ba80fd5fc0f9b61c5e592de035312365ad85b9c78e37"
    sha256 cellar: :any_skip_relocation, sonoma:         "9609c5b392fa18422370ff6e1141699d277c7fda09160188f5c8b1891a47ab8c"
    sha256 cellar: :any_skip_relocation, ventura:        "9609c5b392fa18422370ff6e1141699d277c7fda09160188f5c8b1891a47ab8c"
    sha256 cellar: :any_skip_relocation, monterey:       "9609c5b392fa18422370ff6e1141699d277c7fda09160188f5c8b1891a47ab8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ddfaf7984ff3194c6966fe2765fcd79fae9bc91a5f96a96c9baba7aed1c6885"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=mod", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
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
