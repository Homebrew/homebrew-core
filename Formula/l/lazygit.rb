class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.63.1.tar.gz"
  sha256 "227ff262138440ff68e893f6c95c4e586e954c46913106d84fff78d220e18b6c"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b8f65363692e764ba80f74250aabb138ec40fd597cd1bb7b7e24b732fd6f635"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b8f65363692e764ba80f74250aabb138ec40fd597cd1bb7b7e24b732fd6f635"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b8f65363692e764ba80f74250aabb138ec40fd597cd1bb7b7e24b732fd6f635"
    sha256 cellar: :any_skip_relocation, sonoma:        "8aeecae2195a36c4a0530b53b60104ddaf2503a0e3a084af00123bda08ff6061"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2a021ae9b976673ca44810f83c9fe5f46967a567fe9cf0d0e653e825b7fc477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90ce490b818cffcf7d99cbe05df289fae554c0510596cc84af2b5a4995f89cde"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=#{tap.user}"
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
