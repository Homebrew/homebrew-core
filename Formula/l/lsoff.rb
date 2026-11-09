class Lsoff < Formula
  desc "List listening TCP and UDP ports"
  homepage "https://github.com/yutat23/lsoff"
  url "https://github.com/yutat23/lsoff/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "25117f42705801040ea63bf09cf6396a063d54c0087a7ce6a57554195b5f17ae"
  license "MIT"
  head "https://github.com/yutat23/lsoff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6efbfa1dc5410fe4e579ef79f139c6b5df313a77239860edcce59e8d3ba5fd17"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd5df103dbf79d5239eece0596208095defb8b10ae7602a85b70fc72bfadf6b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be225a4975438bc1adfe420d15acd5124657f784da5917282e57fdfa6dd09083"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d77499ae68810f259ef39b08bdec8e956e7852bcd864c6ceac9566e672bf76c9"
    sha256 cellar: :any,                 x86_64_linux:      "2cf7f24d57bf9e1b2cb3b3d449603b26a9f182f7ec161cd1905c177b05544e4e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lsoff --version")

    output = shell_output("#{bin}/lsoff --kill 2>&1", 2)
    assert_match "-k requires a port", output
  end
end
