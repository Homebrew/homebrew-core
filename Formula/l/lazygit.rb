class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "56f028ad7700cbe4474e5fb09a617649a82d0963820d38757f61a93b31832610"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a88ae047e45eeb490d47ccbeb030a7e8f636010860a70767718906ac69de318"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a88ae047e45eeb490d47ccbeb030a7e8f636010860a70767718906ac69de318"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a88ae047e45eeb490d47ccbeb030a7e8f636010860a70767718906ac69de318"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d32e5f157b7d2c490bafc232f464ec20a5d4b642b885fbbccf0024d9d9466b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10247df1a71982bd67faeb8780c211072af7ea15962d50adfdb10cbe63230082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c594a36aa150b039c4439fb07ecaa008a89682851d4a29e63c5800dbe0293dd7"
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
