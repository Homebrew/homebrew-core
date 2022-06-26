class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.20.0.tar.gz"
  sha256 "77aca0e3660564cc2b9a7f318c5d9065d471f3c5ab0a7d1b6850a5cb6e21904f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a34ac31aaf97187206743f62568203519964ccae2fd95eb1d00e809b3fc0f0f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "230cab894d3a5dcea0b2598514ac981e3b0c8fe90be0708a8faeca984a9ff0e7"
    sha256 cellar: :any_skip_relocation, monterey:       "5a5922f7219e01c9a39632b44c39ee037bfbd929862810ed8177971baf25f1bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "7db8aa453665fa3ca270066243bb8369cbb10e7b64a4b7f6186f23ce6454b9eb"
    sha256 cellar: :any_skip_relocation, catalina:       "70b35f0f705d938ee73f7e4916f87c6e4af15429341501ec6aa06ff0791e2a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8570bd163eadc3359a40e0fb0623cf98ca986ef7d53bb7c8747a992df6ef4630"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/miniserve", "--print-completions", "bash")
    (bash_completion/"miniserve").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/miniserve", "--print-completions", "zsh")
    (zsh_completion/"_miniserve").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/miniserve", "--print-completions", "fish")
    (fish_completion/"miniserve.fish").write fish_output
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/miniserve", "#{bin}/miniserve", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
