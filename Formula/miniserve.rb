class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.14.0.tar.gz"
  sha256 "68e21c35a4577251f656f3d1ccac2de23abd68432810b11556bcc8976bb19fc5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3e86055d260028670e6a3e84f92aa2ca71b47a306861cac5b7ab4227a5f6f603"
    sha256 cellar: :any_skip_relocation, big_sur:       "d17632a810e17807e8a1d748258598a04642fa3d204dc4c69b3defdb2b833277"
    sha256 cellar: :any_skip_relocation, catalina:      "05f5fb030477f8301fdabf12a8a4ef2c4f89018182574d787b66e96c55497404"
    sha256 cellar: :any_skip_relocation, mojave:        "af886d1517b441638707853464c04d22f273810c2a0902bea56a6b9c8458d38a"
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
