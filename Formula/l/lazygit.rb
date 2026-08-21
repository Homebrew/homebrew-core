class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.64.1.tar.gz"
  sha256 "b1df6ee72f17efc0ef95fc20a64821cd9eda3935b81cb98b1719c8266163bd07"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9beb4bfe03e5924bf06b78e3cd04851d83b90fd78d79bfb88cfa2d6cca4dc1c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9beb4bfe03e5924bf06b78e3cd04851d83b90fd78d79bfb88cfa2d6cca4dc1c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9beb4bfe03e5924bf06b78e3cd04851d83b90fd78d79bfb88cfa2d6cca4dc1c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "715c0ecdfae047aa49b8da4e8f0ebc502d18284a829140af6cb738603e0ddf7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1943344398479dac64ef8cca343076dd8b2a5944c4a15eaeec985b54515baede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b9749027df69d7c2d88c679b1daf83af81f24fc064e92f581d872c650b58672"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-X main.version=#{version} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazygit -v")

    system "git", "init", "--initial-branch=main"

    s = testpath/"test.txt"
    pid = spawn(bin/"lazygit", "-l", out: s.to_s, err: [:child, :out])
    sleep 2
    assert_match "Log file does not exist. Run `lazygit --debug` first to create the log file", s.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
