class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.66.2.tar.gz"
  sha256 "fcaad0909af765ef87bd873164a4de78435515ab4d8b04f58d6ad51e8ecd00e5"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db6a66ed7de3bcd899afeace9009710c73b6140247b9db397199b8aec67d6392"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db6a66ed7de3bcd899afeace9009710c73b6140247b9db397199b8aec67d6392"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db6a66ed7de3bcd899afeace9009710c73b6140247b9db397199b8aec67d6392"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "95609ee32af62e7e6a930f64cf27abc25b8361bd55986b0fb58d8d99ff2d3c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8710c6883bd73c4186591fe928cb4887f110d7df7ce76871ef1d332487cff705"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-X main.version=#{version} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"lazygit", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
