class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.37.2.tar.gz"
  sha256 "a885d219b53b3ed0a04a6b3bd09050ee1a13ba50189e0b6779c7768b74b6f137"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97ecc4f3606e2167482973a57a4c9d62532b19cf19681bf914d9c8bdeb3cf8bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53d2637a7446b30544a69668816f5e1fb036985082e86122809064892a6d4847"
    sha256 cellar: :any_skip_relocation, monterey:       "b7d0aeb04093bbc41f78c2d79108937dd41ef335c5087e806f86513d61360cbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc3e9433402a3d21143cbb9688d0ee6e94cad3b447a00b11f40f143c41e2d7f5"
    sha256 cellar: :any_skip_relocation, catalina:       "d89adbc07d4d7aa3675b66ac0ee008f85b7dc9734268c1b527ed59183e01d4f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5d4413c327ffbf9fd6d7eca2523f1a743c525f76018a586140e63a6994884bb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    bash_output = Utils.safe_popen_read(bin/"opa", "completion", "bash")
    (bash_completion/"opa").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"opa", "completion", "zsh")
    (zsh_completion/"_opa").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"opa", "completion", "fish")
    (fish_completion/"opa.fish").write fish_output
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
