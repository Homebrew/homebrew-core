class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.19.5.tar.gz"
  sha256 "6c758467bd546327505717ecab1a0f78a07226509dd5de098112065221882474"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f6f32d4f1574e76963cfa7dfa38baf47347081a94638065e77a07f683386bab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "144d9bbb487e9750e9fa2e1151e599801a4dc0f3ea7f156f43783f0bed76322a"
    sha256 cellar: :any_skip_relocation, monterey:       "3cc0a7d83cc32e22411ecb643d8e6c32381af42c2b9848f1fc3a8a3a3b4ef0b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bb2c74fcacbee819246ced04f58a9946279e9dcef7159c2724ec1c4972109ca"
    sha256 cellar: :any_skip_relocation, catalina:       "de7d10095f44db73744eeceb5a8b18b3ec4a2da4df1b874275e0ed71a85d4332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f38b3863b274345f80a1c5d4a291e43c7ab5aa4afeecf0c02dbcfa289d87fae"
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
