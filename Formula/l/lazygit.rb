class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.62.2.tar.gz"
  sha256 "0bd1cdbaf1a584d2eb2fd14f068a8eaaeaeb80d3e2713c72005de9e4feaf6844"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5df0a87934488219163f45627d9de7d5153affd152bddba6daff9f4ca60c6b60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5df0a87934488219163f45627d9de7d5153affd152bddba6daff9f4ca60c6b60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5df0a87934488219163f45627d9de7d5153affd152bddba6daff9f4ca60c6b60"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f76fd6ddd80ad91511e4d4f30d6310a61fc7ebfe0a5143d4294574ed379aa68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e2c383d1716d57072f2436a06f5ff48d46c4fd8286b9f35e8b672f32b6236cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f19fb1ddb8e7c9f620c5a598080213a10621e185234f15a8141253a736e432e"
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
