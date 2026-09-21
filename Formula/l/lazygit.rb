class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.65.1.tar.gz"
  sha256 "df30ec1a5032b3c5672a30090fe787fb32d4122fd996d6d85e1d10135acfbc89"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d11be3739cf20672d4fb83938ce3e86e27160f239dea4228148d2254121bf18f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d11be3739cf20672d4fb83938ce3e86e27160f239dea4228148d2254121bf18f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d11be3739cf20672d4fb83938ce3e86e27160f239dea4228148d2254121bf18f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d3557238f14e512d8ed7942e77fd8ad8e944d2f17c0d6cf95808bb4d6c6740ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b3a456cd371d4402d16e088e2967b1dabf2a7038149e0e0b57f0495ff25bc776"
  end

  depends_on "go" => :build

  deny_network_access!

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
