class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.19.4.tar.gz"
  sha256 "d85a0e65f74a819709bfba8ab564d60162dba65430233e5582d00a6f81ff820d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c17eee465fdd554981aee2eeb7629b7a8dad355a64b138e7e120cb95e6b77da4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff78a7a1649cf9b48d0258e9c3f7310572522dbd4887fc0278ce23263458a1f6"
    sha256 cellar: :any_skip_relocation, monterey:       "1d06d354efbb2725dd18ac6b5cacce87fb099a3fd76de829e0a2f54cea9f7ff7"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd459d7e494e21fe1051ddbd9e954b33b9d04b98374cb6aa1259dc644b80a4c7"
    sha256 cellar: :any_skip_relocation, catalina:       "f55d2522a9265ac5dab04a71ea084cd379a96dd5eb9d8a5207da5b5504be3602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db9de641cdad7c1fc2d75fa7ee53d8a1b6e2c4417020c136eae2a4594e4f67da"
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
