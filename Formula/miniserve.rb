class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.13.0.tar.gz"
  sha256 "3578fd2dfe8dbebecd15b1e82cfb6d6656fed5e54ae4fccc4e7a6879b61dd1e1"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5af9f4cd4602c298c5186e44227d19258453c8d90745b114bb9a6819c4528bb8"
    sha256 cellar: :any_skip_relocation, big_sur:       "ed00b5ecac34f86ff0cdcd6ee5ee700e2b57b548cad57fccf2131ad767550c95"
    sha256 cellar: :any_skip_relocation, catalina:      "fe8dd08807a8dc19e4d524cdd679edc0bc040c02760675b5a6cb4e1d2f653777"
    sha256 cellar: :any_skip_relocation, mojave:        "3d8675c010f0951211d779953c0f8e9cb832a0bcbb62950c270401858c4f1fa6"
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
