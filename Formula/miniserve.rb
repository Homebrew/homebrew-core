class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.18.0.tar.gz"
  sha256 "24860f103879fd881a522a7ad8f25f2c9dcd5e01287b0485bcabf3e88c719015"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "997a1a800deef687042a2008be644e4ab44d98527f5d451ddb1b205f476e4cbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6a7a5e19a71d96a4f5286a7c234307c83b9d0f8ec33b7853ae1c08535e7e33a"
    sha256 cellar: :any_skip_relocation, monterey:       "11199e4e53bf315e00fbd0f101d96ad0c0491d5e9ea17b8d2c8537a72b09474f"
    sha256 cellar: :any_skip_relocation, big_sur:        "124295b36fc81247fd5d80c507d8144919dc5e19b53c248e8a6768404538635e"
    sha256 cellar: :any_skip_relocation, catalina:       "c98b304e5655acf5671d771286f03976ddf7dabdd11705f528fdf1d2daa8037d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcfa53f25624a56434a33925c98de0ead2331b990444ab37d0f70fa0d66c7188"
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
