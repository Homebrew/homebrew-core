class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.16.0.tar.gz"
  sha256 "89f38b4ae1d09c65b2652a45de301ee92878153124ea98917fc22e26784505cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "27a5deebe32f8d0a39fc5db4e1b4c69dc291f78fd76166338e6d4ffdf8a8bc4b"
    sha256 cellar: :any_skip_relocation, big_sur:       "ba1cdebb2902b75691c45c9d0bbc37cfdd06b47edf9e6cc7a769e37007828dc5"
    sha256 cellar: :any_skip_relocation, catalina:      "13d517463e158b41a6c6ad838681c060a46f4f269b7ee6b054e9bcdf44b06a5a"
    sha256 cellar: :any_skip_relocation, mojave:        "6293a9c5965cf4e96d59104bb8b889f312ac850aa6958c23b16a1ade5cd6398d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa2264c49f9d5190f406402d3f7f1266aa46d1a2ff63e0756db8c29c4264f90f"
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
