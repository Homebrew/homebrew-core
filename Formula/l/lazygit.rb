class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.66.3.tar.gz"
  sha256 "49e80d28e03e53048105f6ebb5afefbe5caacffa8549347d8a59eab3a00dafe1"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "51a23984f012e2aa2f668cb04f83006e1c366a2b67859cfe1f00b8d96075cb66"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "51a23984f012e2aa2f668cb04f83006e1c366a2b67859cfe1f00b8d96075cb66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "51a23984f012e2aa2f668cb04f83006e1c366a2b67859cfe1f00b8d96075cb66"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "691b1c2efe66617462ac456147d548c6556c83b05a185ffd1165b48f543fe029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a5bb764d157993e7e3be455106414162c5a1b1c45047150a3fb27f6440f50642"
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
