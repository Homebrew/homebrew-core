class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.19.2.tar.gz"
  sha256 "353632758dd05fb3f6862fcaea86d9eee2cdf889e97181a880b354fe33e760da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c220213f8c7ca80a236f3709b9f8080789a92d55c077c16668572574872a016"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2824dc86ab6ecbb607d5110b402a20f00503d22d7b7eba162e5d17196d8919d"
    sha256 cellar: :any_skip_relocation, monterey:       "d66a9fcf1266c824a10fe1dbbc474e3a5a4100d7c1f26a4b38192c667d98de8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "bafddffbe202dd758e8e8599d67adfabc623a96c5c2e8e22f2bfb320098cd5fc"
    sha256 cellar: :any_skip_relocation, catalina:       "e23a3c07813e68f1e8cd908bb9ef2efc08b26e91087faa54edc305e03c725ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfc98399a419f5ffea5982017636238a9c4d2473f975411863d8433e591b3542"
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
