class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.23.2.tar.gz"
  sha256 "9817f9083cf338d5f165633865d4b5e6c8e7df6267e04c320119548253fb13cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05c2e8eafb20b4e7c4bcdadc75f8d609bf101169ad975d1eacc2ea9eda2043eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e84961b231b844439e629879f9b87e9321f72def2e642b660dc7eddbc838766"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5314d0640630657124994fa08b8c649e05abb7069b8f15791028511297f24a1f"
    sha256 cellar: :any_skip_relocation, ventura:        "688e7bca62a8852fe0524d0e1b7a6b552c601a39ce80cb8a88749a6348967951"
    sha256 cellar: :any_skip_relocation, monterey:       "789c9cfbc3cb674efde93317e703a3a5b3ab1e0d206942e3400650a933a67668"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf15310f3239506078a6a54c01411b4ec419a88e08ac9544df268f3a13c50b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d7a2c102e8f8394e39f7863f3722201473cc738e002ea815a2683150a8b2ec6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"miniserve", "--print-completions")
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
