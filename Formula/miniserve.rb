class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.19.0.tar.gz"
  sha256 "79905c0da5f87578e166c6cbd6bc5b8a1b49a7f97baaae9d55d215fb0eca3145"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb9d122441f59862104654fddb5ceb9cf6343b7cdd9f8b18b9e8bb45e0c645c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc8c739fa7aaa3b09a4a2c32eee8ceb62b42ae5aadfeb5ead8093f4abf70c561"
    sha256 cellar: :any_skip_relocation, monterey:       "c1721f66e0f570b025733cb620f5166d606a3d3fd2435cea5937fb3ac3dd011b"
    sha256 cellar: :any_skip_relocation, big_sur:        "53f50b77ad0f44c753d16ef9772674f650bd9bf4c1b12f902be3dde040279993"
    sha256 cellar: :any_skip_relocation, catalina:       "0dad23a22e6cab335d6dc0b30f3db4d0a3ab24ca3d6689af19db76692d8fde62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28ada3ec29eecccb4d5b5d83ff63ffd2c46d00112a6efc64ae32dea80dd6cd68"
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
